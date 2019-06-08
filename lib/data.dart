import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:luminus_api/luminus_api.dart';

Authentication _auth;

Future<Authentication> authentication() async {
  if (_auth != null) {
    return _auth;
  } else {
    final storage = FlutterSecureStorage();
    return _auth = Authentication(
        username: await storage.read(key: 'nusnet_id'),
        password: await storage.read(key: 'nusnet_password'));
  }
}

List<Module> modules;
List<Announcement> announcements = new List();
DateTime smsStartDate = DateTime.now();
