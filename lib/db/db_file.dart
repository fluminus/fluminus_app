import 'dart:convert';

import 'package:luminus_api/luminus_api.dart';
import 'db_helper.dart';
import 'package:fluminus/data.dart' as data;

Future<int> insertFile(BasicFile file,
    {String parentId, String fileLocation, String lastUpdated}) async {
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
      'file_location': fileLocation,
      'last_updated': lastUpdated,
      'name': file.fileName,
      'json': json
    });
  } else {
    // TODO: error handling
    throw Exception("This should't happen...");
  }
}

Future<List<Map<String, dynamic>>> _queryByParentId(String parentID) async {
  var query = await dbSelect(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ?',
      whereArgs: [parentID]);
  return query;
}

Future<List<Map<String, dynamic>>> _queryById(String id) async {
  var query = await dbSelect(
      tableName: DatabaseHelper.fileTable, where: 'uuid = ?', whereArgs: [id]);
  return query;
}

Future<List<Directory>> getModuleDirectories(Module module) async {
  var query = await _queryByParentId(module.id);
  if (query.isEmpty) {
    // print('refresh module dirs');
    await refreshModuleDirectories(module);
    query = await _queryByParentId(module.id);
  } else {
    // print('used cached module dirs');
  }
  List<Directory> res = [];
  for (var item in query) {
    res.add(Directory.fromJson(jsonDecode(item['json'])));
  }
  return res;
}

Future<void> refreshModuleDirectories(Module module) async {
  // print(module.id);
  await dbDelete(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ?',
      whereArgs: [module.id]);
  var dirs = await API.getModuleDirectories(data.authentication(), module);
  for (var dir in dirs) {
    await insertFile(dir);
  }
}

Future<List<Directory>> refreshAndGetModuleDirectories(Module module) async {
  await refreshModuleDirectories(module);
  var query = await _queryByParentId(module.id);
  List<Directory> res = [];
  for (var item in query) {
    res.add(Directory.fromJson(jsonDecode(item['json'])));
  }
  return res;
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
  Set<BasicFile> downloaded = {};
  for (var item in items) {
    if (item is File) {
      try {
        var t = await queryFile(item);
        if (!(t['file_location'] == null || t['last_updated'] == null))
          downloaded.add(item);
      } catch (e) {
        // this exception doesn't need to be handled
      }
    }
  }
  await dbDelete(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ? AND file_location IS NULL AND last_updated IS NULL',
      whereArgs: [parent.id]);
  for (var item in items) {
    if (!downloaded.contains(item)) {
      await insertFile(item, parentId: parent.id);
    }
  }
}

Future<List<BasicFile>> refreshAndGetItemsFromDirectory(
    Directory parent) async {
  await refreshItemsFromDirectory(parent);
  var query = await _queryByParentId(parent.id);
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

Future<String> getFileLocation(File file) async {
  var query = await _queryById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in getDownloadUrl');
  }
  return query[0]['file_location'];
}

Future<Map<String, dynamic>> queryFile(File file) async {
  var query = await _queryById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in queryFile');
  }
  return query[0];
}

Future<void> updateFileLocation(File file, String path, DateTime time) async {
  await dbUpdate(DatabaseHelper.fileTable,
      {'file_location': path, 'last_updated': time.toIso8601String()},
      where: 'uuid = ?', whereArgs: [file.id]);
}

Future<DateTime> getLastUpdated(File file) async {
  var query = await _queryById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in getLastUpdated');
  }
  return DateTime.tryParse(query[0]['last_updated']);
}
