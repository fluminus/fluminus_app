import 'dart:convert';
import 'dart:io';

import 'package:luminus_api/luminus_api.dart' as api;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final fileTable = 'file_table';

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
    await db.execute('''
            CREATE TABLE $fileTable (
              uuid TEXT PRIMARY KEY,
              parent_id TEXT NOT NULL,
              is_file BOOLEAN NOT NULL,
              name TEXT NOT NULL,
              json TEXT NOT NULL
            )
          ''');
  }
}
