import 'dart:io';

import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String name,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      _isLoading = true;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        KnubbyApp.userId = authResult.user!.uid;

        FirebaseFirestore.instance
            .collection('users')
            .doc(KnubbyApp.userId)
            .get()
            .then((value) {
          var response = value.data() as Map<String, dynamic>;
          KnubbyApp.userName = response['name'];
        });
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user!.uid}.jpg');

        await ref.putFile(image!).whenComplete(() async {
          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user!.uid)
              .set({
            'userId': authResult.user!.uid,
            'name': name,
            'email': email,
            'image_url': url,
            'counters': {},
            'projects': {},
          });
        });

        KnubbyApp.userId = authResult.user!.uid;
        KnubbyApp.userName = name;
      }
    } on PlatformException catch (error) {
      var message =
          error.message ?? 'An error occured, please check your credentials!';

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          appTitle(),
          const SizedBox(
            height: 10,
          ),
          AuthForm(_submitAuthForm, _isLoading),
        ],
      ),
    );
  }

  Widget appTitle() {
    return Column(
      children: const [
        Text(
          'Knubby',
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.w700,
            fontSize: 60,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'A Knitting Buddy',
          style: TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Color.fromRGBO(131, 89, 227, 1),
          ),
        ),
      ],
    );
  }
}
