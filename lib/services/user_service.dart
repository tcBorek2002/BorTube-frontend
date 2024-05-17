import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:bortube_frontend/main.dart';
import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:flutter/material.dart';
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
  final response = await globalBrowserClient.post(Uri.parse("${baseUrl}login"),
      headers: headers, body: body);

  // Cookie cookie = Cookie.fromSetCookieValue(response.headers['set-cookie']!);
  // document.cookie = cookie.toString();

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
Future<User> getUserBackend(String userId, BuildContext context) async {
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
  };
  final response = await globalBrowserClient
      .get(Uri.parse("${baseUrl}users/$userId"), headers: headers);

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    await userShouldLogin(context);
    throw Exception('User not logged in.');
  } else {
    throw Exception(
        'Failed to retrieve user information. Status code: ${response.statusCode}');
  }
}

/// Creates a new user with the given [email], [password], and [displayName].
/// Returns a [Future] that completes with a [bool] indicating whether the user creation was successful.
Future<bool> createUserBackend(
    String email, String password, String displayName) async {
  final url = Uri.parse("${baseUrl}users");
  final headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    'email': email,
    'password': password,
    'displayName': displayName,
  });

  final response =
      await globalBrowserClient.post(url, headers: headers, body: body);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

/// Updates user information on the backend server.
///
/// Takes in the [userId] of the user and [email], [password], [displayName] as the updated user information.
/// Sends a PUT request to the backend server to update the user information.
/// Returns a [Future] that resolves to a [bool] indicating whether the update was successful.
Future<bool> updateUserBackend(
    String userId, String? email, String? password, String? displayName) async {
  Map<String, dynamic> requestBody = {};

  if (email != null) {
    requestBody['email'] = email;
  }

  if (password != null) {
    requestBody['password'] = password;
  }

  if (displayName != null) {
    requestBody['displayName'] = displayName;
  }

  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  final response = await globalBrowserClient.put(
    Uri.parse("${baseUrl}users/$userId"),
    headers: headers,
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

/// Logs out the user from the backend server.
///
/// Sends a POST request to the backend server to log out the user.
/// Returns a [Future] that resolves to a [bool] indicating whether the logout was successful.
Future<bool> logoutUserBackend() async {
  // document.cookie = "";
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
  };
  final response = await globalBrowserClient.post(Uri.parse("${baseUrl}logout"),
      headers: headers);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
