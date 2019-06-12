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
      'download_time': lastUpdated,
      'name': file.fileName,
      'json': json
    });
  } else {
    // TODO: error handling
    throw Exception("This should't happen...");
  }
}

Future<List<Map<String, dynamic>>> _selectByParentId(String parentID) async {
  var query = await dbSelect(
      tableName: DatabaseHelper.fileTable,
      where: 'parent_id = ?',
      whereArgs: [parentID]);
  return query;
}

Future<List<Map<String, dynamic>>> _selectById(String id) async {
  var query = await dbSelect(
      tableName: DatabaseHelper.fileTable, where: 'uuid = ?', whereArgs: [id]);
  return query;
}

Future<List<Directory>> getModuleDirectories(Module module) async {
  var query = await _selectByParentId(module.id);
  if (query.isEmpty) {
    // print('refresh module dirs');
    await refreshModuleDirectories(module);
    query = await _selectByParentId(module.id);
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
  var query = await _selectByParentId(module.id);
  List<Directory> res = [];
  for (var item in query) {
    res.add(Directory.fromJson(jsonDecode(item['json'])));
  }
  return res;
}

Future<List<BasicFile>> getItemsFromDirectory(Directory parent) async {
  var query = await _selectByParentId(parent.id);
  if (query.isEmpty) {
    await refreshItemsFromDirectory(parent);
    query = await _selectByParentId(parent.id);
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
  var downloadedInDatabase = await dbSelect(
      tableName: DatabaseHelper.fileTable,
      where:
          'parent_id = ? AND file_location IS NOT NULL AND download_time IS NOT NULL',
      whereArgs: [parent.id]);
  // print(downloadedInDatabase);
  Set<BasicFile> downloadedInResponse = {};
  for (var item in items) {
    if (item is File) {
      try {
        var t = await selectFile(item);
        // print(t);
        if (!(t['file_location'] == null || t['download_time'] == null))
          downloadedInResponse.add(item);
      } catch (e) {
        // this exception doesn't need to be handled
      }
    }
  }
  for (var item in downloadedInDatabase) {
    File f = File.fromJson(jsonDecode(item['json']));
    if (!downloadedInResponse.contains(f)) {
      await dbUpdate(DatabaseHelper.fileTable, {'deleted': true},
          where: 'uuid = ?', whereArgs: [f.id]);
    }
  }
  await dbDelete(
      tableName: DatabaseHelper.fileTable,
      where:
          'parent_id = ? AND file_location IS NULL AND download_time IS NULL',
      whereArgs: [parent.id]);
  for (var item in items) {
    if (!downloadedInResponse.contains(item)) {
      await insertFile(item, parentId: parent.id);
    }
  }
}

Future<List<BasicFile>> refreshAndGetItemsFromDirectory(
    Directory parent) async {
  await refreshItemsFromDirectory(parent);
  var query = await _selectByParentId(parent.id);
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

Future<int> deleteDownloadedFile(File file) async {
  var t = await dbSelect(
      tableName: DatabaseHelper.fileTable,
      where: 'uuid = ?',
      whereArgs: [file.id]);
  if (t.length != 1) {
    // TODO: error handling
    throw Exception('error in deleteDownloadedFile');
  } else if (t[0]['deleted'] == 1) {
    return await dbDelete(
        tableName: DatabaseHelper.fileTable,
        where: 'uuid = ?',
        whereArgs: [file.id]);
  } else {
    return await dbUpdate(DatabaseHelper.fileTable,
        {'file_location': null, 'download_time': null, 'deleted': null},
        where: 'uuid = ?', whereArgs: [file.id]);
  }
}

Future<String> getFileLocation(File file) async {
  var query = await _selectById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in getDownloadUrl');
  }
  return query[0]['file_location'];
}

Future<Map<String, dynamic>> selectFile(File file) async {
  var query = await _selectById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in queryFile');
  }
  return query[0];
}

Future<void> updateFileLocation(File file, String path, DateTime time) async {
  await dbUpdate(DatabaseHelper.fileTable,
      {'file_location': path, 'download_time': time.toIso8601String()},
      where: 'uuid = ?', whereArgs: [file.id]);
}

Future<DateTime> getLastUpdated(File file) async {
  var query = await _selectById(file.id);
  if (query.length != 1) {
    // TODO: error handling
    throw Exception('Error in getLastUpdated');
  }
  return DateTime.tryParse(query[0]['download_time']);
}
