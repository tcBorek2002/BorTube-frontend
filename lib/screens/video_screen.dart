import 'package:bortube_frontend/services/video_service.dart';
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
        int? idParsed = int.tryParse(widget.videoID!);
        if (idParsed != null) {
          setState(() {
            video = getVideo(idParsed);
          });
        } else {
          video = Future.value(null);
        }
      } else {
        video = Future.value(null);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video?>(
      future: video,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Text("404 - Video not found");
          }
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
