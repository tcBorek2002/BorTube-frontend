import 'dart:convert';

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
  final response = await http.post(Uri.parse("${baseUrl}login"), body: body);

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
