import 'package:final_project/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RavelryWebScreen extends StatelessWidget {
  final String title;
  final String selectedUrl;

  // final Completer<WebViewController> _controller = Completer<WebViewController>();

  RavelryWebScreen({
    required this.title,
    required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KnubbyApp.pink,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: WebView(
        initialUrl: selectedUrl,
      ),
    );
  }
}
