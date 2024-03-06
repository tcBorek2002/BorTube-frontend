import 'package:bortube_frontend/objects/video.dart';
import 'package:flutter/material.dart';

String formatDuration(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String formattedDuration =
      '${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  return formattedDuration;
}

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Center(
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: const Image(
                  image: AssetImage('assets/thumbnail.png'),
                  height: 170,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(formatDuration(video.duration))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
