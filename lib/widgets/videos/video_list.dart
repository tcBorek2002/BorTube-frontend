import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/widgets/videos/video_card.dart';
import 'package:flutter/material.dart';

class VideoList extends StatelessWidget {
  VideoList({super.key, required this.videos, required this.refreshVideos});

  final List<Video>? videos;
  final Function() refreshVideos;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (videos == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 200,
      child: Scrollbar(
        controller: _scrollController,
        trackVisibility: true,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: videos!.length,
          itemBuilder: (BuildContext context, int index) {
            return VideoCard(
                video: videos![index], refreshVideos: refreshVideos);
          },
        ),
      ),
    );
  }
}
