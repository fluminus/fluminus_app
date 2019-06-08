import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:luminus_api/luminus_api.dart';


Authentication authentication = new Authentication(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
List<Module> modules;
List<Announcement> announcements = new List();
DateTime smsStartDate = DateTime.now();

Future<List<Announcement>> getAllAnnouncements() async {
  modules = await API.getModules(authentication);
  for (Module module in modules) {
    announcements.addAll(await API.getAnnouncements(authentication, module));
  }
  return announcements;
}
