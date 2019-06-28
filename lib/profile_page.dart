import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluminus/login_page.dart';
import 'package:fluminus/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:fluminus/widgets/common.dart';
import 'package:fluminus/db/db_helper.dart' as db;
import 'data.dart' as data;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile profile = data.profile;
  bool _isDarkMode;

  Widget displayName(String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget displayMatricNumber(String number) {
    return Text(
      number,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget displayPersonalParticular(String info) {
    return Text(
      info,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget profileWidget(Profile profile) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: displayName(profile.userNameOriginal)),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: displayMatricNumber(profile.userMatricNo),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: displayPersonalParticular(profile.email),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            profile == null
                ? FutureBuilder(
                    future: API.getProfile(data.authentication()),
                    builder: (context, AsyncSnapshot<Profile> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Profile prof = snapshot.data;
                        data.profile = prof;
                        return profileWidget(prof);
                      } else {
                        return profileWidget(data.profilePlaceholder);
                      }
                    },
                  )
                : profileWidget(profile),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  Text('Spooky Mode 💀'),
                  Switch(
                    activeColor: blue,
                    value: _isDarkMode =
                        Theme.of(context).brightness == Brightness.dark,
                    onChanged: (val) async {
                      setState(() {
                        _isDarkMode = !_isDarkMode;
                      });
                      toggleBrightness(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isDark', _isDarkMode);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RaisedButton(
                  color: greyGreen,
                  child: Text('Log Out'),
                  onPressed: () async {
                    await data.deleteCredentials();
                    Navigator.of(context).pushReplacementNamed(LoginPage.tag);
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RaisedButton(
                  color: blue,
                  child: Text('Clear Database'),
                  onPressed: () async {
                    await db.clearAllTables();
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RaisedButton(
                  color: Colors.cyanAccent,
                  child: Text('Activate notifications'),
                  onPressed: () async {
                    await activatePushNotification();
                  },
                )),
          ],
        ));
  }
}

Future<void> activatePushNotification() async {
  Dio dio = Dio();
  final storage = FlutterSecureStorage();
  final FirebaseMessaging _firebaseMsg = FirebaseMessaging();
  var id = await storage.read(key: 'nusnet_id');
  await dio.get('http://127.0.0.1:3003/api/notification/activate',
      queryParameters: {'id': id, 'fcm_token': await _firebaseMsg.getToken()});
}
