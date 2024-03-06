import 'package:bortube_frontend/objects/video.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/thumbnail.png'),
              height: 170,
            ),
            Row(
              children: [Text("Title"), Text("10:00")],
            )
          ],
        ),
      ),
    );
  }
}
