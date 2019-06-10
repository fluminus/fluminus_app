import 'dart:convert';

import 'package:luminus_api/luminus_api.dart';
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

Future<int> insertFile(BasicFile file) async {
  if (file is Directory) {
    String json = jsonEncode(file.toJson());
    return await dbInsert(DatabaseHelper.fileTable, {
      'uuid': file.id,
      'parent_id': file.parentID,
      'is_file': false,
      'name': file.name,
      'json': json
    });
  } else if (file is File) {
    String json = jsonEncode(file.toJson());
    return await dbInsert(DatabaseHelper.fileTable, {
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

Future<List<BasicFile>> queryFile(String parentID) async {
  var query = await dbQuery(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ?',
      whereArgs: [parentID]);
  List<BasicFile> res;
  for (var item in query) {
    if (item['is_file'] == null) {
      // TODO: error handling
      throw Exception('queryFile error');
    } else if (item['is_file']) {
      res.add(File.fromJson(jsonDecode(item['json'])));
    } else {
      res.add(Directory.fromJson(jsonDecode(item['json'])));
    }
  }
  return res;
}
