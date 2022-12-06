import 'dart:io';

import 'package:final_project/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';

class DatabaseHelper {
  Future<void> updateProjectImage(Project project, File imageFile) async {
    // save the image to Firebase Storage
    final ref = FirebaseStorage.instance.ref().child('project_images').child(
        '${project.maker.trim().replaceAll(RegExp(' +'), '-')}-${project.title.trim().replaceAll(RegExp(' +'), '-')}.jpeg');

    if (imageFile == null) {
      return;
    } else {
      await ref.putFile(imageFile).whenComplete(() async {
        // update the image url
        project.imageUrl = await ref.getDownloadURL();
      });
    }

    // save the project to Firebase Firestore
    FirebaseFirestore.instance.collection('users').doc(KnubbyApp.userId).set({
      'projects': {project.title: project.toJson()}
    }, SetOptions(merge: true));
  }

  static Future<void> updateUserCompletedProjects() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(KnubbyApp.userId)
        .update(
      {
        'completedProjects': FieldValue.increment(1),
        'inProgressProjects': FieldValue.increment(-1),
      },
    );
  }

  static Future<void> addUserinProgressProject() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(KnubbyApp.userId)
        .update(
      {
        'inProgressProjects': FieldValue.increment(1),
      },
    );
  }
}
