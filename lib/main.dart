import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/screens/error_screen.dart';
import 'package:bortube_frontend/screens/home_screen.dart';
import 'package:bortube_frontend/screens/login_screen.dart';
import 'package:bortube_frontend/screens/register_screen.dart';
import 'package:bortube_frontend/screens/user_screen.dart';
import 'package:bortube_frontend/screens/video_screen.dart';
import 'package:bortube_frontend/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() {
  usePathUrlStrategy();
  runApp(ChangeNotifierProvider(
      create: (context) {
        final userProvider = UserProvider();
        userProvider.loadUserFromSharedPreferences();
        return userProvider;
      },
      child: MyApp()));
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
                path: '/user/:id',
                builder: (context, state) =>
                    UserScreen(userId: state.pathParameters['id']),
              ),
              GoRoute(
                  path: '/test',
                  builder: (context, state) => const ErrorScreen()),
              GoRoute(
                  path: '/login',
                  builder: (context, state) => const LoginScreen()),
              GoRoute(
                  path: '/register',
                  builder: (context, state) => const RegisterScreen())
            ])
      ],
      errorBuilder: (context, state) => const ErrorScreen(),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BorTube',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue, brightness: Brightness.dark)
            .copyWith(brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
