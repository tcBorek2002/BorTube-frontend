import 'package:bortube_frontend/objects/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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
                onPressed: user == null
                    ? () => context.go('/login')
                    : () => context.go('/user/${user.id}'),
                icon: const Icon(Icons.account_circle_rounded),
                label: Text(user == null ? 'Login' : user.displayName)),
          )
        ],
      ),
      body: child,
    );
  }
}
