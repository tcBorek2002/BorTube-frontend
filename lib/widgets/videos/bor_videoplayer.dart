import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class BorVideoPlayer extends StatefulWidget {
  const BorVideoPlayer({super.key, required this.videoURL});
  final String videoURL;

  @override
  _BorVideoPlayerState createState() => _BorVideoPlayerState();
}

class _BorVideoPlayerState extends State<BorVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _future;

  Future<void> initBorVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: true,
          looping: false,
          autoInitialize: false);
    });
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoURL));
    _future = initBorVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            return Center(
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            );
          }),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _chewieController.pause();
    super.dispose();
  }
}
