import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:luminus_api/luminus_api.dart';

List<String> images = [
  "assets/image_04.jpg",
  "assets/image_03.jpg",
  "assets/image_02.jpg",
  "assets/image_01.png",
];

List<String> title = [
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
  "Jack the Persian and the Black Castel",
];

Authentication auth = new Authentication(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
List<Module> modules;
Profile profile;
List<Announcement> announcements = new List();

Future<List<Module>> getModules() async {
  if(modules == null) {
    modules = await API.getModules(auth);
  }
  return modules;
}

void refreshModules() async {
  modules = await API.getModules(auth);
}

Future<Profile> getProfile() async {
  if(profile == null) {
    profile = await API.getProfile(auth);
  }
  return profile;
}

void refreshProfile() async {
  profile = await API.getProfile(auth);
}

Future<List<Announcement>> getAnnouncements(Module module) async {
  if(announcements == null) {
    announcements = await API.getAnnouncements(auth, module);
  }
  return announcements;
}

Future<List<Announcement>> getAllAnnouncements() async {
  getModules();
  for (Module module in modules) {
    print("called");
    announcements.addAll(await API.getAnnouncements(auth, module));
  }
  //print(announcements.toString());
  return announcements;
}

void refresAnnouncements(Module module) async {
  announcements = await API.getAnnouncements(auth, module);
}

