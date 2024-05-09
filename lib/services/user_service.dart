import 'dart:convert';
import 'dart:io';

import 'package:bortube_frontend/objects/user.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://localhost:8000/";

/// Logs in the user to the backend server.
///
/// Takes in the [email] and [password] of the user and sends a request to the backend server
/// to authenticate the user. Returns a [Future] that resolves to a [String] representing
/// the authentication token if the login is successful, otherwise throws an exception.
Future<String> loginUserBackend(String email, String password) async {
  String body = jsonEncode(<String, dynamic>{
    'username': email,
    'password': password,
  });

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response = await http.post(Uri.parse("${baseUrl}login"),
      headers: headers, body: body);

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);
    if (body is Map<String, dynamic>) {
      var userId = body['userId'];
      return userId;
    } else {
      throw Exception('Failed parsing userId from response body.');
    }
  } else {
    return "400";
  }
}

/// Retrieves user information from the backend server.
///
/// Takes in the [userId] of the user and sends a GET request to the backend server
/// to retrieve the user information. Returns a [Future] that resolves to a [Map<String, dynamic>]
/// representing the user information if the request is successful, otherwise throws an exception.
Future<User> getUserBackend(String userId) async {
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
  };
  final response =
      await http.get(Uri.parse("${baseUrl}users/$userId"), headers: headers);

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to retrieve user information. Status code: ${response.statusCode}');
  }
}

/// Logs out the user from the backend server.
///
/// Sends a POST request to the backend server to log out the user.
/// Returns a [Future] that resolves to a [bool] indicating whether the logout was successful.
Future<bool> logoutUserBackend() async {
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
  };
  final response =
      await http.post(Uri.parse("${baseUrl}logout"), headers: headers);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
