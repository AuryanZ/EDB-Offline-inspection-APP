import 'package:app/src/models/inspections.model.dart';
import 'package:app/src/services/inspectionExecute.services.dart';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InspectionRecordDB {
  static const int _version = 1;
  static const String _dbName = 'inspectionRecord.db';

  Database? _database;

  void dispose() {
    _database?.close();
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get dbPath async {
    const dbName = _dbName;
    final path = await getDatabasesPath();
    return join(path, dbName);
  }

  Future<Database> _initialize() async {
    final path = await dbPath;

    var database = await openDatabase(path,
        version: _version, onCreate: _createDb, singleInstance: true);
    return database;
  }

  Future<void> _createDb(Database db, int version) async {
    await InspectionExecute().createTable(db);
  }

// set inspection record
  Future<void> insertInspection(Inspections inspection) async {
    final db = await database;
    await db.insert('Inspections', inspection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Inspections>?> getInspections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Inspections');
    return List.generate(maps.length, (i) {
      return Inspections(
        id: maps[i]['id'],
        name: maps[i]['name'],
        codeKey: maps[i]['codeKey'],
        code: maps[i]['code'],
        status: maps[i]['status'] == 1 ? true : false,
        inspectionDate: DateTime.parse(maps[i]['inspectionDate']),
        lastModifedDate: DateTime.parse(maps[i]['lastModifedDate']),
        file: maps[i]['file'],
        data: maps[i]['data'],
      );
    });
  }

  //Get inspection by id
  Future<Inspections?> getInspection(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Inspections', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Inspections(
        id: maps[0]['id'],
        name: maps[0]['name'],
        codeKey: maps[0]['codeKey'],
        code: maps[0]['code'],
        status: maps[0]['status'] == 1 ? true : false,
        inspectionDate: DateTime.parse(maps[0]['inspectionDate']),
        lastModifedDate: DateTime.parse(maps[0]['lastModifedDate']),
        file: maps[0]['file'],
        data: maps[0]['data'],
      );
    }
    return null;
  }

  //Get inspection List by status
  Future<List<Inspections>?> getInspectionList(bool status) async {
    final db = await database;
    final searchStatus = status ? 1 : 0;
    final List<Map<String, dynamic>> maps =
        // await db.query('Inspections');
        await db.query('Inspections',
            where: 'status = ?', whereArgs: [searchStatus]);
    return List.generate(maps.length, (i) {
      return Inspections(
        id: maps[i]['id'],
        name: maps[i]['name'],
        codeKey: maps[i]['codeKey'],
        code: maps[i]['code'],
        status: maps[i]['status'] == 1 ? true : false,
        inspectionDate: DateTime.parse(maps[i]['inspectionDate']),
        lastModifedDate: DateTime.parse(maps[i]['lastModifedDate']),
        file: maps[i]['file'],
        data: maps[i]['data'],
      );
    });
  }

  // Get Count of Inspections which status is false
  Future<int> getInspectionCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Inspections', where: 'status = ?', whereArgs: [0]);
    return maps.length;
  }

  // Update Status of Inspection
  Future<void> updateInspection(Inspections inspection) async {
    final db = await database;
    await db.update(
      'Inspections',
      inspection.toMap(),
      where: 'id = ?',
      whereArgs: [inspection.id],
    );
  }
}
