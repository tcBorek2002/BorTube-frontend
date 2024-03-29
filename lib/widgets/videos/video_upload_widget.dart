import 'package:bortube_frontend/services/video_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class VideoUploadWidget extends StatefulWidget {
  const VideoUploadWidget({super.key});

  @override
  State<VideoUploadWidget> createState() => _VideoUploadWidgetState();
}

class _VideoUploadWidgetState extends State<VideoUploadWidget> {
  bool _isUploading = false;

  Future<void> uploadVideo(BuildContext context) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'video/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uploading video, please wait...')),
        );
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((event) async {
          final bytes = reader.result as List<int>;
          setState(() {
            _isUploading = true;
          });

          final success = await uploadVideoBackend(bytes, file.name);
          setState(() {
            _isUploading = false;
          });
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video uploaded successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error uploading video'),
                  backgroundColor: Colors.red),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isUploading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () => uploadVideo(context),
              child: const Text('Select and Upload Video'),
            ),
    );
  }
}
