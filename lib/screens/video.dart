import 'package:bortube_frontend/services/video_service.dart';
import 'package:flutter/material.dart';

import '../objects/video.dart';

class VideoPage extends StatefulWidget {
  VideoPage({super.key, required this.videoID});
  final int videoID;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<Video> video;

  @override
  void initState() {
    super.initState();
    try {
      video = getVideo(widget.videoID);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
