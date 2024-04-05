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
      ),
      body: child,
    );
  }
}
