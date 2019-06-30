import 'dart:async';
import 'dart:io';

// import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluminus/login_page.dart';
// import 'package:fluminus/widgets/theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  bool _enablePushNotifications = false;

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

  Widget switchWidget(
      String text, bool defaultValue, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Text(text),
          Switch(
            activeColor: Theme.of(context).toggleableActiveColor,
            value: defaultValue,
            onChanged: onChanged,
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
                        if (prof != null) {
                          data.profile = prof;
                          return profileWidget(prof);
                        } else {
                          return profileWidget(data.profilePlaceholder);
                        }
                      } else {
                        return profileWidget(data.profilePlaceholder);
                      }
                    },
                  )
                : profileWidget(profile),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            switchWidget('Spooky Mode 💀',
                _isDarkMode = Theme.of(context).brightness == Brightness.dark,
                (val) async {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
              toggleBrightness(context);
              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool('isDark', _isDarkMode);
              });
            }),
            FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  SharedPreferences prefs = snapshot.data;
                  if (!prefs.containsKey('enablePushNotifications'))
                    prefs.setBool('enablePushNotifications', false);
                  bool toggle = prefs.getBool('enablePushNotifications');
                  _enablePushNotifications = toggle;
                  return switchWidget(
                      'Push notifications', _enablePushNotifications,
                      (val) async {
                    setState(() {
                      _enablePushNotifications = val;
                      prefs.setBool('enablePushNotifications', val);
                    });
                    if (val) {
                      await activatePushNotifications();
                    } else {
                      await deactivatePushNotifications();
                    }
                  });
                } else {
                  return switchWidget(
                      'Push notifications', _enablePushNotifications, (_) {});
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RaisedButton(
                  color: Theme.of(context).errorColor,
                  child: Text('Log Out'),
                  onPressed: () async {
                    await data.deleteCredentials();
                    Navigator.of(context).pushReplacementNamed(LoginPage.tag);
                  },
                )),
            // Padding(
            //     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            //     child: RaisedButton(
            //       color: Theme.of(context).buttonColor,
            //       child: Text('Test crashlytics'),
            //       onPressed: () {
            //         throw Exception('Crashlytics test');
            //       },
            //     )),
            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: RaisedButton(
                  color: Theme.of(context).unselectedWidgetColor,
                  child: Text('Clear Database'),
                  onPressed: () async {
                    await db.clearAllTables();
                  },
                )),
          ],
        ));
  }
}

Future<void> activatePushNotifications() async {
  final FirebaseMessaging _firebaseMsg = FirebaseMessaging();
  print(await _firebaseMsg.getToken());
  _firebaseMsg.configure(onMessage: (Map<String, dynamic> msg) async {
    print("onMessage: $msg");
  });
  if (Platform.isIOS) {
    StreamSubscription iosSubscription;
    iosSubscription = _firebaseMsg.onIosSettingsRegistered.listen((data) async {
      // save the token OR subscribe to a topic here
      // Dio dio = Dio();
      // final storage = FlutterSecureStorage();
      // var id = await storage.read(key: 'nusnet_id');
      // await dio.get('http://127.0.0.1:3003/api/notification/activate',
      //     queryParameters: {
      //       'id': id,
      //       'fcm_token': await _firebaseMsg.getToken()
      //     });
    });
    _firebaseMsg.requestNotificationPermissions(IosNotificationSettings());
  }
}

Future<void> deactivatePushNotifications() async {
  print('deactivated PN');
}
