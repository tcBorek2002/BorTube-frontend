import 'dart:convert';

import 'package:bortube_frontend/objects/video.dart';
import 'package:http/http.dart' as http;

Future<List<Video>> getAllVideos() async {
  final response = await http.get(Uri.parse('http://localhost:8000/videos'));

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

Future<Video> getVideo(int videoID) async {
  final response =
      await http.get(Uri.parse('http://localhost:8000/videos/$videoID'));

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

Future<bool> createVideo(String title, int duration) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/videos'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'title': title,
      'duration': duration,
    }),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<bool> deleteVideo(int id) async {
  final response = await http.delete(
    Uri.parse('http://localhost:8000/videos/$id'),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
