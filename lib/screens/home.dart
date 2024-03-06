import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/widgets/videos/video_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Video> videos = [Video(1, "Hello world", 180), Video(2, "Haa", 222)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BorTube"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            VideoList(videos: videos),
            const Text(
              'Welcome to BorTube!',
            ),
          ],
        ),
      ),
    );
  }
}