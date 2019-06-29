// import 'dart:async';
// import 'dart:io';

// import 'package:fluminus/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

/// Currently this page is used solely for testing purposes.
class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Forum Page',
      )),
      body: WebView(
        initialUrl: 'https://forum.tyhome.site',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
