import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Authentication _auth;
bool _updateCreds = false;

Future<Authentication> authentication() async {
  final storage = FlutterSecureStorage();
  if (_auth == null) {
    _updateCreds = false;
    _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),
        password: await storage.read(key: 'nusnet_password'));
  } else if (_updateCreds) {
    _updateCreds = false;
    _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),
        password: await storage.read(key: 'nusnet_password'));
  }
  return _auth;
}

void updateCredentials() {
  _updateCreds = true;
}

Future<void> deleteCredentials() async {
  final storage = FlutterSecureStorage();
  storage.delete(key: 'nusnet_id');
  storage.delete(key: 'nusnet_password');
  _auth = null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('hasCred', false);
}

DateTime smsStartDate = DateTime.utc(2019, 8, 5);

SharedPreferences sp;
List<Module> modules = [];
Profile profile;
List<Announcement> archivedAnnouncements = [];

Profile profilePlaceholder = Profile(
    userID: 'E0261888',
    userNameOriginal: 'John Doe',
    userMatricNo: 'A0177888Y',
    email: 'user@email.com',
    displayPhoto: false);

Future<void> loadData() async {
  Authentication auth = await authentication();
  sp = await SharedPreferences.getInstance();
  modules = await API.getModules(auth);
  profile = await API.getProfile(auth);
  String result = sp.getString('archivedAnnouncements');
  if (result != null) {
    List maps = json.decode(result);
    archivedAnnouncements = new List();
    for (int i = 0; i < maps.length; i++) {
      archivedAnnouncements.add(Announcement.fromJson(maps[i]));
    }
  } else {
    archivedAnnouncements = new List();
  }
}
