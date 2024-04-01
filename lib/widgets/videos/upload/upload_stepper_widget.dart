import 'package:flutter/material.dart';

class UploadStepper extends StatefulWidget {
  const UploadStepper({super.key});

  @override
  State<UploadStepper> createState() => _UploadStepperState();
}

class _UploadStepperState extends State<UploadStepper> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Video details'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Content for Step 1'),
          ),
        ),
        const Step(
          title: Text('Upload video'),
          content: Text('Content for Step 2'),
        ),
        const Step(
          title: Text("Final check"),
          content: Text("Content for final check"),
        )
      ],
    );
  }
}
