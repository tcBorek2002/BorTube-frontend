import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/videos/upload/upload_video.dart';
import 'package:bortube_frontend/widgets/videos/video_list.dart';
import 'package:bortube_frontend/widgets/videos/upload/video_upload_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Video>> futureVideos;
  late User? _user;

  @override
  void initState() {
    super.initState();
    futureVideos = getAllVideos();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _user = userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<List<Video>>(
              future: futureVideos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return VideoList(
                      videos: snapshot.data,
                      refreshVideos: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            futureVideos = getAllVideos();
                          });
                        });
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              }),
          _user != null
              ? ElevatedButton(
                  onPressed: () async {
                    await showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: UploadVideo(closeDialog: () {
                                Navigator.of(context).pop();
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  setState(() {
                                    futureVideos = getAllVideos();
                                  });
                                });
                              }),
                            ));
                  },
                  child: const Text("Upload new video"))
              : const SizedBox(),
        ],
      ),
    );
  }
}
