import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class ProximityDatabaseProvider {

  static final _dbName = 'uuids.db';
  static final _dbVersion = 1;
  static final _tableName = 'proximityTable';
  static final _table2Name = 'myPastUuidsTable';

  static final columnId = '_id';
  static final columnName = 'uuids';

  ProximityDatabaseProvider._privateConstructor();
  static final ProximityDatabaseProvider instance = ProximityDatabaseProvider._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async{
    await db.execute(
          '''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL)
      '''
      );
    db.execute(
        '''
      CREATE TABLE $_table2Name(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL)
      '''
    );
  }

  Future<int> insert(int table, Map<String, dynamic> row) async{
    if (table == 1) { // encounters table
      Database db = await instance.database;
      return await db.insert(_tableName, row);
    } else { // past uuids table
      Database db = await instance.database;
      return await db.insert(_table2Name, row);
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(int table) async {
      if (table == 1) { // encounters table
        Database db = await instance.database;
        return await db.query(_tableName);
      } else { // past uuids table
        Database db = await instance.database;
        return await db.query(_table2Name);
      }
  }

  Future<int> update (int table, Map<String, dynamic> row) async{
    if (table == 1) { // encounters table
      Database db = await instance.database;
      int id = row[columnId];
      return await db.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
    } else { // past uuids table
      Database db = await instance.database;
      int id = row[columnId];
      return await db.update(_table2Name, row, where: '$columnId = ?', whereArgs: [id]);
    }
  }

  Future<int> delete(int table, int id) async{
    if (table == 1) { // encounters table
      Database db = await instance.database;
      return await db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
    } else {
      Database db = await instance.database;
      return await db.delete(_table2Name, where: '$columnId = ?', whereArgs: [id]);
    }
  }
}
