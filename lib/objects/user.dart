import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String email;
  String displayName;

  User(this.id, this.email, this.displayName);

  factory User.fromJson(dynamic json) {
    print("Decoding: $json");
    if (json is Map<String, dynamic>) {
      // Handle a single video object
      return User(
        json['id'] as String,
        json['email'] as String,
        json['displayName'] as String,
      );
    } else if (json is List<dynamic>) {
      // Handle an array of video objects
      throw const FormatException('Failed: This is not a single Video object.');
    } else {
      // Throw an exception for unsupported JSON format
      throw const FormatException('Failed to load video.');
    }
  }
}

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUserFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? userData = prefs.getStringList('loggedInUser');

    if (userData == null || userData.length < 3) {
      print("User not logged in.");
      setUser(null);
    } else {
      print("User logged in: ${userData[1]}");
      setUser(User(userData[0], userData[1], userData[2]));
    }
  }
}
