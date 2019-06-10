import 'dart:convert';

import 'package:luminus_api/luminus_api.dart' as api;
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

Future<int> _insert(String table, Map<String, dynamic> row) async {
  Database db = await DatabaseHelper.instance.database;
  return await db.insert(table, row);
}

Future<int> insertFile(api.BasicFile file) async {
  if (file is api.Directory) {
    String json = jsonEncode(file.toJson());
    return await _insert(DatabaseHelper.fileTable, {
      'uuid': file.id,
      'parent_id': file.parentID,
      'is_file': false,
      'name': file.name,
      'json': json
    });
  } else if (file is api.File) {
    String json = jsonEncode(file.toJson());
    return await _insert(DatabaseHelper.fileTable, {
      'uuid': file.id,
      'parent_id': file.parentID,
      'is_file': true,
      'name': file.name,
      'json': json
    });
  } else {
    // TODO: error handling
    throw Exception("This should't happen...");
  }
}

Future<List<api.BasicFile>> queryFile(String parentID) async {
  Database db = await DatabaseHelper.instance.database;
  var query = await db.query(DatabaseHelper.fileTable,
      where: 'parent_id = ?', whereArgs: [parentID]);
  List<api.BasicFile> res;
  for(var item in query) {
    if(item['is_file'] == null) {
      // TODO: error handling
      throw Exception('queryFile error');
    } else if(item['is_file']) {
      res.add(api.File.fromJson(item['json']));
    } else {
      res.add(api.Directory.fromJson(item['json']));
    }
  }
  return res;
}
