import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: InkWell(
          onTap: () => context.go(''),
          child: const Image(
            image: AssetImage('assets/logo.png'),
            height: 45,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.account_circle_rounded),
                label: const Text("Log in")),
          )
        ],
      ),
      body: child,
    );
  }
}
