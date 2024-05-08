import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/user/user_info_form.dart';
import 'package:bortube_frontend/widgets/videos/bor_videoplayer.dart';
import 'package:flutter/material.dart';

import '../objects/video.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.userId});
  final String? userId;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<User?> user;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.userId != null) {
        setState(() {
          user = getUserBackend(widget.userId!);
        });
      } else {
        user = Future.value(null);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text("404 - User not found");
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Card(
                child: Column(
                  children: [
                    const Text(
                      'Your profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    UserInfoForm(user: snapshot.data!),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Quick actions:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.movie_rounded),
                            label: const Text("My videos"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            )),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.warning_rounded),
                          label: const Text("Delete account"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text("Logout"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
