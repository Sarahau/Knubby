import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/main.dart';
import 'package:final_project/widgets/project_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import '../widgets/project_image_picker.dart';
import '../models/project.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  final _makerId = KnubbyApp.userId;
  final _maker = KnubbyApp.userName;
  var _imageUrl = '';
  File? _projectImageFile;

  void _setProjectImageFile(File image) {
    _projectImageFile = image;
  }

  Future<void> _addProject(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      // saves the form
      _formKey.currentState!.save();

      // save the image to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('project_images').child(
          '${_maker.trim().replaceAll(RegExp(' +'), '-')}-${_title.trim().replaceAll(RegExp(' +'), '-')}.jpeg');

      if (_projectImageFile == null) {
        return;
      } else {
        await ref.putFile(_projectImageFile!).whenComplete(() async {
          _imageUrl = await ref.getDownloadURL();
        });
      }

      // create the Project
      Project newProject = Project(
        _title,
        _maker,
        _imageUrl,
        DateTime.now(),
      );

      // save the project to Firebase Firestore
      FirebaseFirestore.instance.collection('users').doc(_makerId).set({
        'projects': {_title: newProject.toJson()}
      }, SetOptions(merge: true));

      // add a new in progress project to the user
      DatabaseHelper.addUserinProgressProject();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Projects',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: KnubbyApp.darkPurple,
              ),
        ),
        border: null,
        trailing: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: ((context) => AlertDialog(
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
                      'Add a New Project!',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    content: dialogContent(context),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _addProject(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  )),
            );
          },
          child: const Icon(
            CupertinoIcons.plus,
            color: KnubbyApp.darkPurple,
          ),
        ),
      ),
      child: SafeArea(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_makerId)
                      .snapshots(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    Map<String, dynamic> userProjects =
                        userSnapshot.data!['projects'] as Map<String, dynamic>;

                    var projectKeys = userProjects.keys;

                    if (projectKeys.isEmpty) {
                      return Center(
                        child: Text(
                          'Add some projects!',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      );
                    }

                    // to sort the projects by date
                    Map<String, Project> userProjectMap = {};

                    userProjects.forEach((projectTitle, projectData) {
                      userProjectMap.putIfAbsent(
                          projectTitle, () => Project.fromJson(projectData));
                    });

                    var sortedProjectMap = Map.fromEntries(
                        userProjectMap.entries.toList()
                          ..sort((p1, p2) => p1.value.compareTo(p2.value)));

                    print(sortedProjectMap.toString());
                    //TODO use this sorted map...

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4 / 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: userProjects.length,
                      itemBuilder: ((context, index) {
                        Project currProject = Project.fromJson(
                          userProjects[projectKeys.elementAt(index)],
                        );
                        return ProjectCard(currProject);
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: 300,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProjectImagePicker(_setProjectImageFile),
                TextFormField(
                  key: const ValueKey('title'),
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title for your project';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
