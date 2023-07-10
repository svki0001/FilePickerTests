import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class FileVideoTest extends StatefulWidget {
  const FileVideoTest({Key? key}) : super(key: key);

  @override
  State<FileVideoTest> createState() => _FileVideoTestState();
}

class _FileVideoTestState extends State<FileVideoTest> {
  VideoPlayerController? _videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_videoPlayerController != null) ...[
          AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          ),
        ],
        ElevatedButton(
          onPressed: selectVideo,
          child: const Text('Pick Video File'),
        ),
      ],
    );
  }

  void loadVideoPlayer(File file) {
    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
    }

    _videoPlayerController = VideoPlayerController.file(file);
    _videoPlayerController!.initialize().then((value) {
      _videoPlayerController!.play();
      setState(() {});
    });
  }

  void selectVideo() async {
    //ask for permission
    await Permission.manageExternalStorage.request();

    PermissionStatus status = await Permission.manageExternalStorage.status;

    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied   before but not permanently.
      debugPrint("Permission Denied");
      return;
    }

    // You can can also directly ask the permission about its status.
    if (await Permission.storage.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      debugPrint("Permission Restricted");
      return;
    }

    if (status.isGranted) {
      debugPrint("Permission Granted");
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        setState(() {
          debugPrint("###########################");
          debugPrint(result.files.single.path!);
          debugPrint("###########################");

          File file = File(result.files.single.path!);
          loadVideoPlayer(file);
        });
      } else {
        // User canceled the picker
      }
    }
  }
}
