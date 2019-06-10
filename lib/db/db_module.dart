import 'dart:convert';

import 'package:luminus_api/luminus_api.dart' as api;
import 'package:fluminus/data.dart' as data;
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

Future<int> insertModule(api.Module mod) async {
  return await dbInsert(DatabaseHelper.moduleTable, {
    'uuid': mod.id,
    'name': mod.name,
    'course_name': mod.courseName,
    'json': jsonEncode(mod.toJson())
  });
}

Future<List<api.Module>> allModules() async {
  var query = await dbQuery(tableName: DatabaseHelper.moduleTable);
  if (query.isEmpty) {
    return refreshModules();
  } else {
    List<api.Module> res = List();
    for (var item in query) {
      // TODO: error handling
      res.add(api.Module.fromJson(jsonDecode(item['json'])));
    }
    print('cached modules');
    return res;
  }
}

Future<List<api.Module>> refreshModules() async {
  print('refreshing modules');
  var modules = await api.API.getModules(data.authentication());
  await dbDelete(tableName: DatabaseHelper.moduleTable);
  for (var mod in modules) {
    await insertModule(mod);
  }
  return await allModules();
}
