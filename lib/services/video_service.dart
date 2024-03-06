import 'dart:convert';

import 'package:bortube_frontend/objects/video.dart';
import 'package:http/http.dart' as http;

Future<List<Video>> getAllVideos() async {
  // final response = await http
  //     .get(Uri.parse('http://localhost:8000/videos'));
  final response = await http
      .get(Uri.http('localhost:8000', 'videos'));

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