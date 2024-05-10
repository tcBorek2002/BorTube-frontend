import 'package:bortube_frontend/objects/user.dart';
import 'package:bortube_frontend/objects/video.dart';
import 'package:bortube_frontend/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

String formatDuration(int seconds) {
  Duration duration = Duration(seconds: seconds);
  String formattedDuration =
      '${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  return formattedDuration;
}

class VideoCard extends StatefulWidget {
  const VideoCard(
      {super.key, required this.video, required this.refreshVideos});

  final Video video;
  final Function() refreshVideos;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  User? _user;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _user = userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Center(
        child: Card(
          child: Column(
            children: [
              InkWell(
                onTap: () => context.go('/video/${widget.video.id}'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Image(
                        image: AssetImage('assets/thumbnail.png'), height: 144),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      widget.video.duration != null
                          ? Text(formatDuration(widget.video.duration!))
                          : const SizedBox.shrink(),
                      _user != null && _user!.id == widget.video.user.id
                          ? IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Deleting video...')),
                                );
                                deleteVideo(widget.video.id);
                                widget.refreshVideos();
                              },
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                              ))
                          : const SizedBox.shrink()
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
