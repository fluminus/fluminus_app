import 'luminus_api/luminus_api.dart';
import 'luminus_api/module_response.dart';
import 'luminus_api/profile_response.dart';
import 'luminus_api/announcement_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

Auth auth = new Auth(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
List<Module> modules;
Profile profile;

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