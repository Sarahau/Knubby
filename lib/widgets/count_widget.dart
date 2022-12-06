import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/project.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CountWidget extends StatefulWidget {
  @override
  State<CountWidget> createState() => _CountWidgetState();

  Project project;
  int count;
  CountWidget(this.project, this.count, {super.key});
}

class _CountWidgetState extends State<CountWidget> {
  void _incrementCounter(bool increase) {
    setState(() {
      if (increase) {
        widget.count++;
      } else {
        widget.count--;
      }
    });

    // update project counterCount
    widget.project.counterCount += increase ? 1 : -1;

    FirebaseFirestore.instance.collection('users').doc(KnubbyApp.userId).set({
      'projects': {widget.project.title: widget.project.toJson()}
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () => _incrementCounter(true),
          icon: const Icon(CupertinoIcons.chevron_up),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(22),
                ),
              ),
            ),
            Text(
              widget.count.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        IconButton(
          onPressed: () => widget.count <= 0 ? null : _incrementCounter(false),
          icon: const Icon(CupertinoIcons.chevron_down),
        ),
      ],
    );
  }
}
