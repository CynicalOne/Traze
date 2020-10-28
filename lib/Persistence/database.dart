import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:traze/Persistence/proximity.dart';
import 'package:sqflite/sqflite.dart';

// import 'proximity.dart';

class ProximityDatabaseProvider {
  ProximityDatabaseProvider._();

  static final ProximityDatabaseProvider db = ProximityDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "proximity.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE ProximityId ("
              "id integer primary key AUTOINCREMENT,"
              "datetime integer,"
              "proximityid TEXT"
              ")");
        });
  }

  Future<List<ProximityId>> getAllProximityIds() async {
    final db = await database;
    var res = await db.query("ProximityId");
    List<ProximityId> list = res.map((c) => ProximityId.fromMap(c)).toList();
    return list;
  }

  Future<ProximityId> getProximityId(int id) async {
    final db = await database;
    var res = await db.query("Proximity", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ProximityId.fromMap(res.first) : null;
  }

  /* for testing */
  void testPrintProxIDText(int id) async {
    final db = await database;
    var res = await db.query("Proximity", where: "id = ?", whereArgs: [id]);
    List<ProximityId> idlist = [];
    if (res.length > 0) {
      for (int i = 0;  i < res.length; i++) {
        idlist.add(ProximityId.fromMap(res[i]));
      }
      for (int j = 0; j < res.length; j++) {
        print("the id in the database is: ");
        print(idlist[j].getproxidstring());
        print("\n");
      }
    }
    return;
  }

  addProximityId(ProximityId pi) async {
    final db = await database;
    var raw = await db.insert(
        "ProximityId",
        pi.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return raw;
  }

  deleteProximityId(int id) async {
    final db = await database;
    return db.delete("ProximityId", where: "id = ? ", whereArgs: [id]);
  }

  clearProximityDatabase() async {
    final db = await database;
    db.delete("ProximityId");
  }

}
