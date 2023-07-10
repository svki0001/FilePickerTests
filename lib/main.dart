import 'package:flutter/material.dart';
import 'package:storage_test/file_image_test.dart';
import 'package:storage_test/file_video_test.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Storage Test'),
        ),
        body: const Center(
          child: Column(
            children: [
              FileImageTest(),
              FileVideoTest(),
            ],
          ),
        ),
      ),
    );
  }
}
