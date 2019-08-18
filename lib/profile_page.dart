import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluminus/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luminus_api/luminus_api.dart' as luminus;
import 'package:fluminus/widgets/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluminus/db/db_helper.dart' as db;
import 'data.dart' as data;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as provider;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode;
  Widget _background;
  
  


  @override
  void initState() {
    super.initState();
    String backgroundPath = data.sp.getString('backgroundPath');
    if(backgroundPath != null) {
      _background = Image.file(File(backgroundPath), fit: BoxFit.cover,
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,);
    }
  }

  

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var appDir = await getApplicationDocumentsDirectory();
    final String appDirPath = appDir.path;
    var fileName = provider.basename(image.path);
    var localImage = await image.copy('$appDirPath/$fileName');
    data.sp.setString('backgroundPath', localImage.path);
    setState(() {
      _background = FittedBox(child: Image.file(File(localImage.path)), fit: BoxFit.fill);
    });
  }


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

  Widget profileWidget(luminus.Profile profile) {
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

  Widget userInfoHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(data.profile.userNameOriginal),
      accountEmail: Text(data.profile.email),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          data.profile.userNameOriginal.substring(0, 1),
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }

  Widget defaultBackground(BuildContext context) {
 
      return Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset('assets/nus_lion.png', fit: BoxFit.contain),
          ),
          Text(
            'Happy new semester !' + '\n',
            style: TextStyle(fontSize: 30, fontFamily: 'Hanalei'),
          ),
          Text(
            'You can upload your timetable here!',
            style: Theme.of(context).textTheme.subhead,
          ),
          Text(
            '(Swipe from the left edge to see more functions!)\n',
            style: Theme.of(context).textTheme.subtitle,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/6),
          child:
          OutlineButton(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 1.5, //width of the border
            ),
            highlightColor: Theme.of(context).primaryColor,
            child: Text('Upload Image'),
            shape: StadiumBorder(),
            onPressed: () async{
              await getImage();
            },
          )
        ),
        ],
      ));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          userInfoHeader(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          switchWidget('Dark Mode',
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
          // FutureBuilder(
          //   future: SharedPreferences.getInstance(),
          //   builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       SharedPreferences prefs = snapshot.data;
          //       if (!prefs.containsKey('enablePushNotifications'))
          //         prefs.setBool('enablePushNotifications', false);
          //       bool toggle = prefs.getBool('enablePushNotifications');
          //       _enablePushNotifications = toggle;
          //       return switchWidget(
          //           'Push notifications', _enablePushNotifications,
          //           (val) async {
          //         setState(() {
          //           _enablePushNotifications = val;
          //           prefs.setBool('enablePushNotifications', val);
          //         });
          //         if (val) {
          //           await activatePushNotifications();
          //         } else {
          //           await deactivatePushNotifications();
          //         }
          //       });
          //     } else {
          //       return switchWidget(
          //           'Push notifications', _enablePushNotifications, (_) {});
          //     }
          //   },
          // ),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.black,
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
          ListTile(
            leading: Icon(Icons.clear_all),
            title: Text('Clear Database'),
            onTap: () async {
              await db.clearAllTables();
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud_upload),
            title: Text('Upload Image'),
            onTap: () async {
              await getImage();
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () async {
              await data.deleteCredentials();
              Navigator.of(context).pushReplacementNamed(LoginPage.tag);
            },
          ),
        ],
      )),
      body: _background == null ? Container(child:defaultBackground(context)) : Container(child: _background),
    );
  }
}

Future<void> activatePushNotifications() async {
  final FirebaseMessaging _firebaseMsg = FirebaseMessaging();
  print(await _firebaseMsg.getToken());
  _firebaseMsg.configure(onMessage: (Map<String, dynamic> msg) async {
    print("onMessage: $msg");
  });
  if (Platform.isIOS) {
    // StreamSubscription iosSubscription;
    // iosSubscription = _firebaseMsg.onIosSettingsRegistered.listen((data) async {
    //   save the token OR subscribe to a topic here
    //   Dio dio = Dio();
    //   final storage = FlutterSecureStorage();
    //   var id = await storage.read(key: 'nusnet_id');
    //   await dio.get('http://127.0.0.1:3003/api/notification/activate',
    //       queryParameters: {
    //         'id': id,
    //         'fcm_token': await _firebaseMsg.getToken()
    //       });
    // });
    _firebaseMsg.requestNotificationPermissions(IosNotificationSettings());
  }
}

Future<void> deactivatePushNotifications() async {
  print('deactivated PN');
}
