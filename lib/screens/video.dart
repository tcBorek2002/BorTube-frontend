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
  late Future<Video> video;
  late bool found;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.videoID != null) {
        int idParsed = int.parse(widget.videoID!);
        video = getVideo(idParsed);
        found = true;
      } else {
        found = false;
      }
    } catch (e) {
      print(e.toString());
      found = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return found ? const Placeholder() : const Text("404: Video not found");
  }
}
