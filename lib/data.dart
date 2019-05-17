import 'package:luminus_api/luminus_api.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Authentication authentication;
Profile profile;
List<Module> modules;
List<Announcement> announcements;

initialData(List<String> args) async{
  load();
  authentication = new Authentication(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
  profile = await API.getProfile(authentication);
  modules = await API.getModules(authentication);
  announcements = await getAllAnnouncements();
}

Future<List<Announcement>> getAllAnnouncements() async {
  for (Module module in modules) {
    announcements.addAll(await API.getAnnouncements(authentication, module));
  }
  return announcements;
}

