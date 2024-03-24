import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/videos/upload_video.dart';
import 'package:bortube_frontend/widgets/videos/video_list.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Video>> futureVideos;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    futureVideos = getAllVideos();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://bortube-dxh7dweqezf2hmet.z01.azurefd.net/bortubevideoscontainer/bee.mp4')); // Replace with your video URL
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Video> videos = [
      Video(1, "Hello world", 180),
      Video(2, "Haa", 222)
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // SizedBox(
          //   width: 300,
          //   child: AspectRatio(
          //     aspectRatio: _videoPlayerController.value.aspectRatio,
          //     child: Chewie(
          //       controller: _chewieController,
          //     ),
          //   ),
          // ),
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
          ElevatedButton(
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: UploadVideo(closeDialog: () {
                            Navigator.of(context).pop();
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                futureVideos = getAllVideos();
                              });
                            });
                          }),
                        ));
              },
              child: const Text("Upload new video"))
        ],
      ),
    );
  }
}
