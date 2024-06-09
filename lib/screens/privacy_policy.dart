import 'package:flutter/material.dart';
import 'dart:html' as html;

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  void showPrivacyPolicy() {
    html.window.open(
        "https://drive.google.com/file/d/1iYTFf6poxt4_0aBuX3RmvSH3BThqHKmT/view?usp=sharing",
        "Privacy Policy");
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: showPrivacyPolicy, child: const Text("Privacy Policy"));
  }
}
