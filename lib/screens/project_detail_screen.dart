import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/main.dart';
import 'package:final_project/widgets/count_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/database_helper.dart';
import '../models/project.dart';

class ProjectDetailScreen extends StatefulWidget {
  Project project;

  ProjectDetailScreen(this.project);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  double? _progressRate;

  // update project progress rate in database
  void updateProgressRate(Project project) {
    project.updateProgressRate(_progressRate!);

    // if the project progress is 100%, update the finish time!
    if (project.progressRate >= 100) {
      project.updateFinishTime(DateTime.now());
    }

    FirebaseFirestore.instance.collection('users').doc(KnubbyApp.userId).set({
      'projects': {project.title: project.toJson()}
    }, SetOptions(merge: true));
  }

  // update project counter Count in the database
  void updateCounterCount(int newCount) {
    // update the database counterCount
    FirebaseFirestore.instance.collection('users').doc(KnubbyApp.userId).set({
      'projects': {widget.project.title: widget.project.toJson()}
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            widget.project.title,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: KnubbyApp.darkPurple),
          ),
          border: null,
        ),
        child: SafeArea(
          child: Center(
            child: ListView(
              children: [
                userProjectImage(),
                Text(
                  'Project started on ${widget.project.prettyPrintDate(
                    widget.project.startTime,
                  )}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.project.progressRate < 100)
                  incompletedProjectWidgets(context),
                if (widget.project.progressRate >= 100)
                  completedProjectWidgets(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget incompletedProjectWidgets(BuildContext context) {
    return Column(
      children: [
        progressSlider(context),
        counterWidget(context),
      ],
    );
  }

  Widget completedProjectWidgets(BuildContext context) {
    return Column(
      children: [
        Text(
            '${widget.project.title} completed on ${widget.project.prettyPrintDate(
          widget.project.finishTime!,
        )}!'),
      ],
    );
  }

  Widget userProjectImage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onLongPress: () => _showImageUpdateActionSheet(context),
        child: Container(
          height: 300,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            image: DecorationImage(
              image: NetworkImage(
                widget.project.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget progressSlider(BuildContext context) {
    return Column(
      children: [
        Text(
          'Project Progress: ${widget.project.progressRate.round().toString()}%',
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 20.0,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 11.0,
              pressedElevation: 4.0,
            ),
            thumbColor: Colors.white,
            valueIndicatorColor: Colors.grey[100],
            valueIndicatorTextStyle: const TextStyle(
              color: KnubbyApp.darkPurple,
              fontSize: 20.0,
            ),
          ),
          child: SizedBox(
            width: 250,
            child: Slider(
              value: _progressRate ?? widget.project.progressRate,
              max: 100,
              divisions: 100,
              label:
                  '${_progressRate?.round().toString() ?? widget.project.progressRate.round().toString()}%',
              onChanged: (value) {
                setState(() {
                  _progressRate = value;
                });
              },
              onChangeEnd: (double value) {
                // once the user lets go of the slider, then update the database
                setState(() {
                  updateProgressRate(widget.project);
                });

                // project completed
                if (value >= 100.0) {
                  DatabaseHelper.updateUserCompletedProjects();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget counterWidget(BuildContext context) {
    return Column(
      children: [
        Text(
          'Row Counter',
          style: Theme.of(context).textTheme.headline3,
        ),
        GestureDetector(
          onLongPress: () {
            _showCounterUpdateActionSheet(context);
          },
          child: CountWidget(
            widget.project,
            widget.project.counterCount,
          ),
        ),
      ],
    );
  }

  void _showCounterUpdateActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Row Counter'),
        message: const Text(
            'Would you like to update the Row Counter for this project?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              widget.project.counterCount = 0;
              updateCounterCount(0);
              Navigator.pop(context);
            },
            child: const Text('Reset Row Counter'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => updateCounterValueDialog(context),
              );
            },
            child: const Text('Update Row Counter Value'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget updateCounterValueDialog(BuildContext context) {
    int newCount = widget.project.counterCount;

    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            30.0,
          ),
        ),
      ),
      title: Text(
        'Change the Row Counter value',
        style: Theme.of(context).textTheme.headline1,
      ),
      content: TextField(
        onChanged: (value) {
          newCount = int.parse(value);
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'New value',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.project.counterCount = newCount;
            updateCounterCount(newCount);
            Navigator.pop(context); // close textfield dialog
            Navigator.pop(context); // close action sheet
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  Future<void> _updateImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage!.path);

    DatabaseHelper().updateProjectImage(widget.project, pickedImageFile);
  }

  void _showImageUpdateActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Update Picture'),
        message: const Text(
            'Would you like to update the picture for this project?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              _updateImage();
              Navigator.pop(context);
            },
            child: const Text('Update Picture'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
