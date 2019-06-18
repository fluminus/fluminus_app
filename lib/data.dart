import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' as main;

Authentication _auth;
bool _updateCreds = false;

Future<Authentication> authentication() async {
  if (_auth == null) {
    print('first time auth');
    _updateCreds = false;
    final storage = FlutterSecureStorage();
    _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),    
        password: await storage.read(key: 'nusnet_password'));
        /*print(_auth.username);
        String id = await storage.read(key: 'nusnet_id';
        print(id);*/
        
  } else {
    if (_updateCreds) {
      print('updating auth');
      _updateCreds = false;
      final storage = FlutterSecureStorage();
      _auth = Authentication(
          username: await storage.read(key: 'nusnet_id'),
          password: await storage.read(key: 'nusnet_password'));
    } else {
      // print('cached auth');
    }
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
  prefs.setBool('hasCred', true);
}

DateTime smsStartDate = DateTime.now();

Future<void> loadData() async{
  Authentication auth = await authentication();
  main.modules = await API.getModules(auth);
  main.profile = await API.getProfile(auth);
}
