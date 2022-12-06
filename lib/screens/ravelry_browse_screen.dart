import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ravelry_helper.dart';
import '../models/ravelry_project.dart';
import '../screens/ravelry_project_detail_screen.dart';
import 'loading_screen.dart';
import '../main.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  RavelryProject? ravelryProject;

  @override
  void initState() {
    super.initState();
    loadProject();
  }

  void loadProject() async {
    ravelryProject = await RavelryHelper.getProject();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Ravelry Project',
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: ravelryProject == null
                ? null
                : IconButton(
                    icon: const Icon(
                      CupertinoIcons.arrow_clockwise,
                      color: KnubbyApp.darkPink,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        ravelryProject = null;
                      });
                      loadProject();
                      setState(() {});
                    },
                  ),
            border: null,
          ),
          child: ravelryProject == null
              ? const LoadingScreen()
              : RavelryProjectDetailScreen(ravelryProject!)),
    );
  }
}
