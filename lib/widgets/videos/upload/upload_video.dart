import 'package:bortube_frontend/services/video_service.dart';
import 'package:bortube_frontend/widgets/videos/upload/upload_overview.dart';
import 'package:bortube_frontend/widgets/videos/upload/upload_stepper_widget.dart';
import 'package:bortube_frontend/widgets/videos/upload/video_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key, required this.closeDialog});

  final Function() closeDialog;

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late TabController _tabController;
  bool _videoSelected = false;
  List<int> _videoBytes = [];
  late String _fileName = "";
  late String _fileSize = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.previousIndex == 0) {
        submitVideo();
      } else if (_tabController.previousIndex == 1 &&
          _tabController.index == 2) {
        if (!_videoSelected) {
          _tabController.animateTo(1);
        }
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void submitVideo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Uploading video...')),
      // );
      _tabController.animateTo(1);
      // createVideo(titleController.text, int.parse(durationController.text));
      // widget.closeDialog();
    } else {
      _tabController.animateTo(0);
    }
  }

  void onFileSelected(List<int> bytes, String fileName, String fileSize) {
    setState(() {
      _videoSelected = true;
      _videoBytes = bytes;
      _fileName = fileName;
      _fileSize = fileSize;
    });
    _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Select video"),
            backgroundColor: Colors.transparent,
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(
                icon: Icon(Icons.info_rounded),
                text: "Video details",
              ),
              Tab(
                icon: Icon(Icons.upload_file_rounded),
                text: "Upload video",
              ),
              Tab(
                icon: Icon(Icons.check_circle_rounded),
                text: "Final check",
              )
            ]),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabBarView(controller: _tabController, children: [
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            onFieldSubmitted: (text) => submitVideo(),
                            controller: titleController,
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.text_fields_rounded),
                              border: OutlineInputBorder(),
                              labelText: 'Video title',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            onFieldSubmitted: (text) => submitVideo(),
                            controller: descriptionController,
                            keyboardType: TextInputType.multiline,
                            minLines: 2,
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description of the video.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.schedule_rounded),
                              border: OutlineInputBorder(),
                              labelText: 'Video description',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () => {submitVideo()},
                            child: const Text('Continue'),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: [
                    VideoUploadWidget(
                      onUpload: onFileSelected,
                    ),
                    _videoSelected
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.done_rounded,
                                color: Colors.green,
                              ),
                              Text(
                                _fileName,
                                style: const TextStyle(color: Colors.green),
                              )
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              UploadOverview(
                  title: titleController.text,
                  description: descriptionController.text,
                  bytes: _videoBytes,
                  fileName: _fileName,
                  fileSize: _fileSize),
            ]),
          ),
        ),
      ),
    );
  }
}
