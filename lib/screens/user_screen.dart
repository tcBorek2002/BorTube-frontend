import 'dart:html';

import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/services/user_service.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/user/user_info_form.dart';
import 'package:bortube_frontend/widgets/videos/bor_videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/video.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.userId});
  final String? userId;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<User?> user;
  bool deleteLoading = false;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.userId != null) {
        setState(() {
          user = getUserBackend(widget.userId!, context);
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

  Future<void> exportUserData() async {
    if (widget.userId == null) {
      return;
    }
    var userObj = await getUserBackend(widget.userId!, context);
    print(userObj.permissionGrantedDate);
    // Make CSV document from userObj and let the user save it:
    var csv = "id,email,displayName,permissionGrantedDate\n";
    csv +=
        "${userObj.id},${userObj.email},${userObj.displayName},${userObj.permissionGrantedDate}\n";
    var blob = Blob([csv]);
    var url = Url.createObjectUrlFromBlob(blob);
    AnchorElement(href: url)
      ..setAttribute("download", "BorTubeUserDataTakeOut.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  Future<void> logoutUser(bool dontShowScaffoldMessenger) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("loggedInUser");

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(null);

    await logoutUserBackend();

    if (!dontShowScaffoldMessenger) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been logged out.'),
          backgroundColor: Colors.green,
        ),
      );
    }
    context.go('/');
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
                    UserInfoForm(
                      user: snapshot.data!,
                      shouldCreate: false,
                    ),
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
                            onPressed: exportUserData,
                            icon: const Icon(Icons.download_rounded),
                            label: const Text("Export my data (csv)")),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Delete account"),
                                    content: const Text(
                                        "Are you sure you want to delete your account? Your data will be deleted forever."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                      ElevatedButton.icon(
                                        label: const Text("Delete account"),
                                        icon: deleteLoading
                                            ? Container(
                                                width: 24,
                                                height: 24,
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 3,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.delete_forever_rounded),
                                        onPressed: deleteLoading
                                            ? null
                                            : () async {
                                                setState(() {
                                                  deleteLoading = true;
                                                });
                                                bool deleted =
                                                    await deleteUserBackend(
                                                            snapshot.data!.id,
                                                            context)
                                                        .catchError((e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Failed to delete account.'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  return false;
                                                });
                                                if (!deleted) {
                                                  setState(() {
                                                    deleteLoading = false;
                                                  });
                                                  return;
                                                }
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Account deleted.'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                                setState(() {
                                                  deleteLoading = false;
                                                });
                                                logoutUser(true);
                                              },
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.warning_rounded),
                          label: const Text(
                            "Delete account",
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            logoutUser(false);
                          },
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
