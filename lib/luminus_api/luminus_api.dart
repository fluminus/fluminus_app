import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'announcement_response.dart';
import 'module_response.dart';
import 'profile_response.dart';
import 'file_response.dart';
import 'download_response.dart';

main(List<String> args) async {
  Auth auth = new Auth(
      password: DotEnv().env['LUMINUS_PASSWORD'],
      username: DotEnv().env['LUMINUS_USERNAME']);
  var modules = await API.getModules(auth);
  for (Module mod in modules) {
    print(mod.courseName);
  }
}

class API {
  static Auth myAuth = new Auth(
      username: DotEnv().env['LUMINUS_USERNAME'],
      password: DotEnv().env['LUMINUS_PASSWORD']);

  static Future<Map> rawAPICall(
      {Auth auth, String path, bool isTest = false}) async {
    String url;
    if (!isTest)
      url =
          "${DotEnv().env['API_URL']}/api/v1/username/${auth.username}/password/${auth.password}$path";
    else {
      url = "http://139.162.28.8:4001/api/v1/test$path";
      print(url);
    }
    var response = await http.get(url);

    // Thanks to https://stackoverflow.com/questions/52774561/flutter-remove-escape-sequence-in-dart?rq=1
    // this is how you deal with escaped json strings...
    Map parsed = jsonDecode(jsonDecode(response.body));

    return parsed;
  }

  static Future<List<Module>> getModules(Auth auth) async {
    Map resp = await API.rawAPICall(auth: auth, path: "/module");
    var modules = new ModuleResponse.fromJson(resp);
    return modules.data;
  }

  static Future<List<Announcement>> getAnnouncements(
      Auth auth, Module module) async {
    Map resp =
        await API.rawAPICall(auth: auth, path: "/announcements/${module.id}");
    var announcements = new AnnouncementResponse.fromJson(resp);
    return announcements.data;
  }

  static Future<Profile> getProfile(Auth auth) async {
    Map resp = await API.rawAPICall(auth: auth, path: "/profile");
    var profile = new Profile.fromJson(resp);
    return profile;
  }

  static Future<List<Directory>> getModuleDirectories(
      Auth auth, Module module) async {
    Map resp =
        await API.rawAPICall(auth: auth, path: "/files/parentID/${module.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  static Future<List<Directory>> getSubdirectories(
      Auth auth, Directory dir) async {
    Map resp =
        await API.rawAPICall(auth: auth, path: "/files/parentID/${dir.id}");
    return (new SubdirectoryResponse.fromJson(resp)).data;
  }

  static Future<List<BasicFile>> getItemsFromDirectory(
      Auth auth, Directory dir) async {
    // Get the subdirectories
    var fileResp = FileResponse.fromJson(await API.rawAPICall(
        auth: auth,
        path: "/files/directoryID/${dir.id}/allowUpload/${dir.allowUpload}"));
    var dirResp = SubdirectoryResponse.fromJson(
        await API.rawAPICall(auth: auth, path: "/files/parentID/${dir.id}"));
    List<BasicFile> list = new List();
    if (fileResp != null) list.addAll(fileResp.data);
    if (dirResp != null) list.addAll(dirResp.data);
    return list;
  }

  static Future<String> getDownloadUrl(Auth auth, File file) async {
    Map resp =
        await API.rawAPICall(auth: auth, path: "/files/download/id/${file.id}");
    return (new DownloadResponse.fromJson(resp)).data;
  }
}

class Auth {
  // necessary stuff for authentication
  String username;
  String password;
  Auth({this.username, this.password});
}
