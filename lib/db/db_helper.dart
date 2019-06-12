import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

export 'db_file.dart';
export 'db_module.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final fileTable = 'file_table';
  static final moduleTable = 'module_table';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print('Creating db...');
    await db.execute('''
      PRAGMA foreign_keys = 1
      ''');

    /// Create file table
    await db.execute('''
            CREATE TABLE $fileTable (
              uuid TEXT PRIMARY KEY,
              parent_id TEXT NOT NULL,
              is_file BOOLEAN NOT NULL,
              file_location TEXT,
              download_time TEXT,
              deleted BOOLEAN,
              name TEXT NOT NULL,
              json TEXT NOT NULL
            )
          ''');

    /// Create module table
    await db.execute('''
            CREATE TABLE $moduleTable (
              uuid TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              course_name TEXT NOT NULL,
              json TEXT NOT NULL
            )
          ''');
  }
}

Future<int> dbInsert(String table, Map<String, dynamic> row) async {
  Database db = await DatabaseHelper.instance.database;
  return await db.insert(table, row);
}

Future<List<Map<String, dynamic>>> dbSelect(
    {@required String tableName, String where, List whereArgs}) async {
  Database db = await DatabaseHelper.instance.database;
  return await db.query(tableName, where: where, whereArgs: whereArgs);
}

Future<int> dbDelete(
    {@required String tableName, String where, List whereArgs}) async {
  Database db = await DatabaseHelper.instance.database;
  return await db.delete(tableName, where: where, whereArgs: whereArgs);
}

Future<void> clearAllTables() async {
  Database db = await DatabaseHelper.instance.database;
  await db.delete(DatabaseHelper.fileTable);
  await db.delete(DatabaseHelper.moduleTable);
}

Future<int> dbUpdate(String table, Map<String, dynamic> values,
    {String where, List whereArgs}) async {
  Database db = await DatabaseHelper.instance.database;
  return await db.update(table, values, where: where, whereArgs: whereArgs);
}
