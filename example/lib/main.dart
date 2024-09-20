import 'package:flutter/material.dart';
import 'package:simple_video_image_picker/simple_video_image_picker.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton.tonal(
          onPressed: () {
            SimpleVideoImagePicker.pick(context: context);
          },
          child: const Text("Open Picker"),
        ),
      ),
    );
  }
}
