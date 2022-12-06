import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProjectImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  const ProjectImagePicker(this.imagePickFn);

  @override
  State<ProjectImagePicker> createState() => _ProjectImagePickerState();
}

class _ProjectImagePickerState extends State<ProjectImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 200,
    );
    final pickedImageFile = File(pickedImage!.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 225,
      child: Container(
          decoration: BoxDecoration(
            image: _pickedImage == null
                ? null
                : DecorationImage(
                    image: FileImage(_pickedImage!),
                    fit: BoxFit.cover,
                  ),
            color: Theme.of(context).primaryColor,
          ),
          child: _pickedImage == null
              ? IconButton(
                  icon: const Icon(CupertinoIcons.camera),
                  onPressed: _pickImage,
                )
              : null),
    );
  }
}
