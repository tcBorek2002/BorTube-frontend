import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/widgets/videos/video_card.dart';
import 'package:flutter/material.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key, required this.videos});

  final List<Video>? videos;

  @override
  Widget build(BuildContext context) {
    if(videos == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: videos!.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoCard(video: videos![index]);
        },
      ),
    );
  }
}
