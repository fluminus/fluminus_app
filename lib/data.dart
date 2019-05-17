import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:flutter_dotenv/flutter_dotenv.dart';




  Authentication authentication = new Authentication(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
  List<Announcement> announcements;


Future<List<Announcement>> getAllAnnouncements() async {
  List<Module> modules = await API.getModules(authentication);
  for (Module module in modules) {
    announcements.addAll(await API.getAnnouncements(authentication, module));
  }
  return announcements;
}

