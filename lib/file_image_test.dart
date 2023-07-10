import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FileImageTest extends StatefulWidget {
  const FileImageTest({super.key});

  @override
  State<FileImageTest> createState() => _FileImageTestState();
}

class _FileImageTestState extends State<FileImageTest> {
  String? _path;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_path != null) Image.file(File(_path!)),
        ElevatedButton(
          onPressed: selectImage,
          child: const Text('Pick Image File'),
        ),
      ],
    );
  }

  void selectImage() async {
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
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.path != null) {
        setState(() {
          debugPrint("###########################");
          debugPrint(result.files.single.path!);
          debugPrint("###########################");

          _path = result.files.single.path;
        });
      } else {
        // User canceled the picker
      }
    }
  }
}
