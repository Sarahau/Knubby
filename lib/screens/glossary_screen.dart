import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:azlistview/azlistview.dart';

import '../helpers/load_abbreviations.dart';
import './glossary_scroll_page.dart';

class GlossaryScreen extends StatefulWidget {
  GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Glossary',
            style: Theme.of(context).textTheme.headline5,
          ),
          border: null),
      child: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('glossary')
              .orderBy(
                'index',
                descending: false,
              )
              .snapshots(),
          builder: (ctx, abbrevSnapshot) {
            if (abbrevSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final abbrevDocs = abbrevSnapshot.data!.docs;

            List<Map<String, String>> abbrevs = [];

            for (var abbreviation in abbrevDocs) {
              String abbrev = abbreviation['abbreviation'];
              String meaning = abbreviation['meaning'];
              Map<String, String> abbrevMap = {abbrev: meaning};

              abbrevs.add(abbrevMap);
            }

            return GlossaryScrollPage(abbrevs: abbrevs);
          },
        ),
      ),
    );
  }
}
