import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key, required this.closeDialog});

  final Function() closeDialog;

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void submitVideo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading video...')),
      );
      widget.closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Stack(
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
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a duration using numbers only';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.schedule_rounded),
                      border: OutlineInputBorder(),
                      labelText: 'Video duration (seconds)',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: submitVideo,
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
