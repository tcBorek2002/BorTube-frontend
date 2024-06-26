import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bortube_frontend/main.dart';
import 'package:bortube_frontend/objects/createVideoDto.dart';
import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

const videosURL = "/api/videos";

Future<void> userShouldLogin(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("loggedInUser");

  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(null);

  await logoutUserBackend();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('You need to login before you can do this!'),
      backgroundColor: Colors.red,
    ),
  );
  context.go('/login');
}

Future<List<Video>> getAllVideos() async {
  final response = await globalBrowserClient.get(Uri.parse(videosURL));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Video.fromJsonList(jsonDecode(response.body) as List<dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load videos');
  }
}

Future<Video> getVideo(String videoID) async {
  final response =
      await globalBrowserClient.get(Uri.parse('$videosURL/$videoID'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Video.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('404 - Video not found');
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load video');
  }
}

Future<CreateVideoDto> createVideo(String title, String description,
    int duration, String fileName, BuildContext context) async {
  String body = jsonEncode(<String, dynamic>{
    'title': title,
    'description': description,
    'fileName': fileName,
    'duration': duration,
  });
  final response = await globalBrowserClient.post(
    Uri.parse(videosURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
  if (response.statusCode == 201) {
    return CreateVideoDto.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    await userShouldLogin(context);
    throw Exception('401 - Unauthorized');
  } else {
    throw Exception('500 - Failed to create video.');
  }
}

Future<bool> videoUploaded(String videoId, String fileName) async {
  final response = await globalBrowserClient.post(
    Uri.parse('$videosURL/$videoId/uploaded'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'fileName': fileName,
    }),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['uploaded'];
  } else {
    throw Exception('Failed to create video.');
  }
}

Future<bool> deleteVideo(String id) async {
  final response = await globalBrowserClient.delete(
    Uri.parse('$videosURL/$id'),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<int> uploadVideoBackend(
    String title, String description, List<int> bytes, String filename) async {
  final videoFile =
      http.MultipartFile.fromBytes('video', bytes, filename: filename);

  final request = http.MultipartRequest('POST', Uri.parse(videosURL));
  request.files.add(videoFile);

  final jsonBody = json.encode({'title': title, 'description': description});
  request.fields['data'] = jsonBody;
  request.headers['Content-Type'] = 'multipart/form-data';
  request.fields['title'] = title;
  request.fields['description'] = description;

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  if (response.statusCode == 201) {
    final responseBody = jsonDecode(response.body);
    if (responseBody.containsKey('videoId') && responseBody['videoId'] is int) {
      return responseBody['videoId'];
    } else {
      return -1;
    }
  } else {
    print(response.body.toString());
    return -1;
  }
}

Future<int> uploadAzure(List<int> bytes, String filename, String azureSASUrl,
    String videoId) async {
  // final videoFile =
  //     http.MultipartFile.fromBytes('video', bytes, filename: filename);

  var client = BrowserClient();
  client.withCredentials = false;

  final response = await client.put(Uri.parse(azureSASUrl),
      headers: {
        'x-ms-blob-type': 'BlockBlob',
        'x-ms-tags': 'videoId=$videoId',
        'Content-Type': 'application/octet-stream'
      },
      body: bytes);
  client.close();
  if (response.statusCode == 201) {
    print("Video uploaded to Azure");
    return 1;
  } else {
    print(response.body.toString());
    return -1;
  }
}
