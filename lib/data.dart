import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Authentication _auth;
bool _updateCreds = false;

Future<Authentication> authentication() async {
  final storage = FlutterSecureStorage();
  // print(await storage.read(key: 'nusnet_id'));
  // print(await storage.read(key: 'nusnet_password'));
  if (_auth == null) {
    // print('first time auth');
    _updateCreds = false;
    _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),
        password: await storage.read(key: 'nusnet_password'));
  } else if (_updateCreds) {
    // print('updating auth');
    _updateCreds = false;
    _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),
        password: await storage.read(key: 'nusnet_password'));
  } else {
    // print('cached auth');
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
  // _auth = null;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('hasCred', false);
}

DateTime smsStartDate = DateTime.now();

List<Module> modules;
Profile profile;
Profile profilePlaceholder = Profile(
    userID: 'E0261888',
    userNameOriginal: 'John Doe',
    userMatricNo: 'A0177888Y',
    email: 'user@email.com',
    displayPhoto: false);

Future<void> loadData() async {
  Authentication auth = await authentication();
  modules = await API.getModules(auth);
  profile = await API.getProfile(auth);
  print(profile);
}
