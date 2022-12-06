import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class LoadAbbreviations {
  static var abbrev = [];
  static var meaning = [];

  static void clearArrays() {
    abbrev = [];
    meaning = [];
  }

  static Future<void> load() async {
    var abbrevFile = File(
        '/Users/sarah/Development/playground/final_project/assets/knitting/abbreviations.txt');

    var meaningFile = File(
        '/Users/sarah/Development/playground/final_project/assets/knitting/meanings.txt');

    await abbrevFile.readAsLines().then((List<String> lines) {
      for (var line in lines) {
        print(line);
        abbrev.add(line);
      }
    });

    await meaningFile.readAsLines().then((List<String> lines) {
      for (var line in lines) {
        print(line);

        meaning.add(line);
      }
    });
    await updateDB();
  }

  static Future<void> updateDB() async {
    for (var i = 0; i < abbrev.length; i++) {
      print('added');
      FirebaseFirestore.instance.collection('glossary').add({
        'abbreviation': abbrev[i],
        'meaning': meaning[i],
        'index': i,
      });
    }
  }
}
