import 'package:bortube_frontend/screens/error_screen.dart';
import 'package:bortube_frontend/screens/home_screen.dart';
import 'package:bortube_frontend/screens/video_screen.dart';
import 'package:bortube_frontend/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root bor");
  final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "shell bor");

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/',
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
            builder: (context, state, child) {
              return NavBar(
                child: child,
              );
              // return child;
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
              ),
              GoRoute(
                path: '/video/:id',
                builder: (context, state) =>
                    VideoPage(videoID: state.pathParameters['id']),
              ),
              GoRoute(
                  path: '/test',
                  builder: (context, state) => const ErrorScreen())
            ])
      ],
      errorBuilder: (context, state) => const ErrorScreen(),
    );

    return MaterialApp.router(
      title: 'BorTube',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
            .copyWith(brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
