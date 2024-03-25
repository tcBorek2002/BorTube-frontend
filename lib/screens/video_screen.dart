import 'package:bortube_frontend/services/video_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../objects/video.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.videoID});
  final String? videoID;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<Video?> video;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

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
    return FutureBuilder<Video?>(
      future: video,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null) {
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
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
