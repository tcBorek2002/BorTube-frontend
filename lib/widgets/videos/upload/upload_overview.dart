import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UploadOverview extends StatelessWidget {
  const UploadOverview(
      {super.key,
      required this.title,
      required this.description,
      required this.bytes,
      required this.fileName,
      required this.fileSize});
  final String title;
  final String description;
  final List<int> bytes;
  final String fileName;
  final String fileSize;

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
            Expanded(
                child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            )),
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
              children: [
                Text(
                  description,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
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
            Text(fileName),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Badge(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(fileSize),
              ),
            )
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: ElevatedButton(
              onPressed: () {}, child: const Text("Start uploading")),
        )
      ],
    );
  }
}
