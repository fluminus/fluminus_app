import 'dart:convert';

import 'package:luminus_api/luminus_api.dart';
import 'package:meta/meta.dart';
import 'db_helper.dart';
import 'package:fluminus/data.dart' as data;

Future<int> insertFile(BasicFile file, {String parentId}) async {
  if (file is Directory) {
    String json = jsonEncode(file.toJson());
    return await dbInsert(DatabaseHelper.fileTable, {
      'uuid': file.id,
      'parent_id': file
          .parentID, // Strange enough, for folders, this property is fine...
      'is_file': false,
      'name': file.name,
      'json': json
    });
  } else if (file is File) {
    String json = jsonEncode(file.toJson());
    return await dbInsert(DatabaseHelper.fileTable, {
      'uuid': file.id,
      'parent_id': parentId ??
          file.parentID, // LumiNUS sucks so much that for files, [id] and [parent_id] are the same...
      'is_file': true,
      'name': file.fileName,
      'json': json
    });
  } else {
    // TODO: error handling
    throw Exception("This should't happen...");
  }
}

Future<List<Map<String, dynamic>>> _queryByParentId(String parentID) async {
  var query = await dbQuery(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ?',
      whereArgs: [parentID]);
  return query;
}

Future<List<Map<String, dynamic>>> _queryById(String id) async {
  var query = await dbQuery(
      tableName: DatabaseHelper.fileTable, where: 'uuid = ?', whereArgs: [id]);
  return query;
}

Future<List<Directory>> getModuleDirectories(Module module) async {
  var query = await _queryByParentId(module.id);
  if (query.isEmpty) {
    await refreshModuleDirectories(module);
    query = await _queryByParentId(module.id);
  }
  List<Directory> res = [];
  for (var item in query) {
    res.add(Directory.fromJson(jsonDecode(item['json'])));
  }
  return res;
}

Future<void> refreshModuleDirectories(Module module) async {
  var dirs = await API.getModuleDirectories(data.authentication(), module);
  for (var dir in dirs) {
    await insertFile(dir);
  }
}

Future<List<BasicFile>> getItemsFromDirectory(Directory parent) async {
  var query = await _queryByParentId(parent.id);
  if (query.isEmpty) {
    await refreshItemsFromDirectory(parent);
    query = await _queryByParentId(parent.id);
  }
  List<BasicFile> res = [];
  for (var item in query) {
    if (item['is_file'] == null) {
      // TODO: error handling
      throw Exception('getItemsFromDirectory error');
    } else if (item['is_file'] == 1) {
      res.add(File.fromJson(jsonDecode(item['json'])));
    } else {
      res.add(Directory.fromJson(jsonDecode(item['json'])));
    }
  }
  return res;
}

Future<void> refreshItemsFromDirectory(Directory parent) async {
  var items = await API.getItemsFromDirectory(data.authentication(), parent);
  for (var item in items) {
    await insertFile(item, parentId: parent.id);
  }
}

Future<String> getFileLocation(File file) async {
  var query = await _queryById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in getDownloadUrl');
  }
  return query[0]['file_location'];
}

Future<void> updateFileLocation(File file, String path, DateTime time) async {
  await dbUpdate(DatabaseHelper.fileTable,
      {'file_location': path, 'last_updated': time.toIso8601String()},
      where: 'uuid = ?', whereArgs: [file.id]);
}
