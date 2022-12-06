import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/main.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  late String userName;
  late int completedProjects;
  late int inProgressProjects;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Material(
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: 1000,
                height: 280,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(175),
                    bottomRight: Radius.circular(175),
                  ),
                  color: KnubbyApp.purple,
                ),
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(KnubbyApp.userId)
                    .snapshots(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  Map<String, dynamic> userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _userProfile(context, userData['image_url']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _userStatsBuilder('# of Projects\nCompleted',
                                userData['completedProjects'] ?? 0, context),
                            _userStatsBuilder('# of Projects\nin Progress',
                                userData['inProgressProjects'] ?? 0, context),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _userProfile(BuildContext context, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: KnubbyApp.darkPurple,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          KnubbyApp.userName,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: KnubbyApp.darkPurple,
              ),
        ),
      ],
    );
  }

  Widget _userStatsBuilder(String title, int statNum, BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 16,
              ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          statNum.toString(),
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 30,
              ),
        ),
      ],
    );
  }
}
