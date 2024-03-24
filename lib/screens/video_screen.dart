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
  late bool found = false;
  String hello = "Loading";

  @override
  void initState() {
    super.initState();
    try {
      if (widget.videoID != null) {
        int idParsed = int.parse(widget.videoID!);
        setState(() {
          video = getVideo(idParsed);
          video.then((value) => print(value.title));

          // found = true;
          // hello = "Found";
        });
      } else {
        setState(() {
          found = false;
          hello = "Error";
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        found = false;
        hello = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video>(
      future: video,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
