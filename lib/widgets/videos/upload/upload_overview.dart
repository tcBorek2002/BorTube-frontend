import 'package:bortube_frontend/services/video_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class UploadOverview extends StatefulWidget {
  const UploadOverview(
      {super.key,
      required this.title,
      required this.description,
      required this.bytes,
      required this.fileName,
      required this.fileSize,
      required this.closeDialog});
  final String title;
  final String description;
  final List<int> bytes;
  final String fileName;
  final String fileSize;
  final Function closeDialog;

  @override
  State<UploadOverview> createState() => _UploadOverviewState();
}

class _UploadOverviewState extends State<UploadOverview> {
  bool _isUploading = false;

  void onStartUploading() {
    setState(() {
      _isUploading = true;
    });

    uploadVideoBackend(
            widget.title, widget.description, widget.bytes, widget.fileName)
        .then((result) {
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("The video was successfully uploaded!."),
          backgroundColor: Colors.green,
        ));
        context.go("/video/$result");
        widget.closeDialog();
      } else {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Something went wrong when uploading the video. Please try again later."),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Overview",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Text(
              "Title: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "Description: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.description,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            )),
          ],
        ),
        Row(
          children: [
            const Text(
              "File: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.fileName),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Badge(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(widget.fileSize),
              ),
            )
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: _isUploading
              ? const Column(
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Video is now uploading. This can take a while. Don't close this window.",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: onStartUploading,
                  child: const Text("Start uploading")),
        )
      ],
    );
  }
}
