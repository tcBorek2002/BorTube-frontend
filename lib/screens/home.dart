import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/videos/video_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Video>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = getAllVideos();
  }

  @override
  Widget build(BuildContext context) {
    final List<Video> videos = [
      Video(1, "Hello world", 180),
      Video(2, "Haa", 222)
    ];

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
            FutureBuilder<List<Video>>(
                future: futureVideos,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return VideoList(videos: snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                }),
            const Text(
              'Welcome to BorTube!',
            ),
            ElevatedButton(
              onPressed: () => {print(getAllVideos())},
              child: const Text("Load videos"),
            )
          ],
        ),
      ),
    );
  }
}
