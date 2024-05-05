import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/videos/bor_videoplayer.dart';
import 'package:flutter/material.dart';

import '../objects/video.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.videoID});
  final String? videoID;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<Video?> video;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.videoID != null) {
        setState(() {
          video = getVideo(widget.videoID!);
        });
      } else {
        video = Future.value(null);
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
    return FutureBuilder<Video?>(
      future: video,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text("404 - Video not found");
          } else if (snapshot.data?.videoUrl == null) {
            return const Text("404 - Video not found");
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: BorVideoPlayer(
                      videoURL: snapshot.data!.videoUrl!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: Card(
                            color:
                                Theme.of(context).cardColor.withOpacity(0.95),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: CircleAvatar(
                                          child: Icon(Icons.person_rounded),
                                        ),
                                      ),
                                      Text(
                                        "Username",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 0, 8),
                                    child: Text(
                                      snapshot.data!.description,
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  )
                ],
              ),
            )),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
