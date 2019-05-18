import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:luminus_api/luminus_api.dart';
import 'package:collection/collection.dart';

Authentication authentication = new Authentication(username: DotEnv().env['LUMINUS_USERNAME'], password: DotEnv().env['LUMINUS_PASSWORD']);
List<Module> modules;
List<Announcement> announcements = new List();
Function twoListsAreDeepEqual = const DeepCollectionEquality().equals;

Future<List<Module>> getModules() async {
  modules = await API.getModules(authentication);
  return modules;
}

Future<List<Announcement>> getAllAnnouncements() async {
  modules = await API.getModules(authentication);
  for (Module module in modules) {
    announcements.addAll(await API.getAnnouncements(authentication, module));
  }
  return announcements;
}

Widget processIndicator = Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );



