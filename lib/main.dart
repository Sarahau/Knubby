import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './screens/auth_screen.dart';
import './screens/profile_screen.dart';
import 'screens/ravelry_browse_screen.dart';
import './screens/glossary_screen.dart';
import './screens/projects_screen.dart';
import 'screens/loading_screen.dart';
import './helpers/color_helper.dart';
// import './helpers/load_abbreviations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // to update the database with terms for glossary
  // LoadAbbreviations.clearArrays();
  // LoadAbbreviations.load();

  runApp(KnubbyApp());
}

class KnubbyApp extends StatelessWidget {
  KnubbyApp({super.key});

  static String userId = '';
  static String userName = '';
  static const Color purple = Color.fromRGBO(167, 173, 249, 1);
  static const Color darkPurple = Color.fromRGBO(131, 89, 227, 1);
  static const Color pink = Color.fromRGBO(245, 201, 217, 1);
  static const Color darkPink = Color.fromRGBO(254, 114, 182, 1);

  final List<Widget> screensList = [
    const BrowseScreen(),
    const ProjectsScreen(),
    GlossaryScreen(),
    ProfileScreen(),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knubby',
      theme: ThemeData(
        primarySwatch: ColorHelper.createMaterialColor(purple),
        accentColor: ColorHelper.createMaterialColor(pink),
        accentIconTheme: ThemeData.light().iconTheme.copyWith(color: darkPink),
        fontFamily: 'Comfortaa',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w700,
                fontSize: 50,
              ),
              headline5: const TextStyle(
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w600,
                fontSize: 28,
                color: darkPink,
              ),
              headline3: const TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: darkPurple,
              ),
              headline2: const TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 16,
                color: Color(0xFF9E9E9E),
              ),
              headline1: const TextStyle(
                fontFamily: 'Comfortaa',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) => !userSnapshot.hasData
            ? const AuthScreen()
            : CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: const Text(
                    'Knubby',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      fontSize: 28,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: Transform.rotate(
                        angle: 180 * pi / 180,
                        child: const Icon(CupertinoIcons.square_arrow_left)),
                  ),
                  border: null,
                ),
                child: CupertinoTabScaffold(
                  tabBar: CupertinoTabBar(
                    backgroundColor: Theme.of(context).accentColor,
                    activeColor: Theme.of(context).accentIconTheme.color,
                    inactiveColor: ColorHelper.createMaterialColor(
                        darkPink.withOpacity(0.55)),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.globe),
                        label: 'Browse',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.chart_bar),
                        label: 'Projects',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.book),
                        label: 'Glossary',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                  tabBuilder: (context, index) {
                    return CupertinoTabView(
                      builder: (ctx) => screensList[index],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
