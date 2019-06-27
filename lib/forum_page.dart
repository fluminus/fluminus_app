import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Currently this page is used solely for testing purposes.
class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final FirebaseMessaging _firebaseMsg = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMsg.getToken().then((val) {
      print(val);
    });
    _firebaseMsg.configure(onMessage: (Map<String, dynamic> msg) async {
      print("onMessage: $msg");
    });
    if (Platform.isIOS) {
      StreamSubscription iosSubscription;
            iosSubscription = _firebaseMsg.onIosSettingsRegistered.listen((data) {
                // save the token  OR subscribe to a topic here
            });
            _firebaseMsg.requestNotificationPermissions(IosNotificationSettings());
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Forum Page',
      )),
    );
  }
}
