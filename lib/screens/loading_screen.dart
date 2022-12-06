import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('./assets/images/grey_logo.png'),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText(
                'Loading...',
                textStyle: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.grey,
                    ),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          )
        ],
      ),
    );
  }
}
