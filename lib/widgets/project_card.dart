import 'dart:math';

import 'package:final_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/project_detail_screen.dart';
import '../models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard(this.project, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor:
                  Theme.of(context).backgroundColor.withOpacity(0.8),
              title: Text(
                project.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: ((context) => ProjectDetailScreen(project)),
                  ),
                );
              },
              child: Hero(
                tag: project.title,
                child: Image.network(
                  project.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (project.finishTime != null)
          Container(
            decoration: BoxDecoration(
              color: KnubbyApp.purple.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Transform.rotate(
                angle: pi * -30 / 180,
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
