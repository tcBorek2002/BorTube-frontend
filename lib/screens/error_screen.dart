import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("404: Page not found"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () => {},
          child: const Text("Go to home page"),
        ),
      ),
    );
  }
}
