import 'package:app/src/models/inspections.model.dart';
import 'package:app/src/services/inspectionExecute.services.dart';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InspectionRecordDB {
  static const int _version = 1;
  static const String _dbName = 'inspectionRecord.db';

  Database? _database;
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
        inspectionDate: maps[i]['inspectionDate'],
        lastModifedDate: maps[i]['lastModifedDate'],
        file: maps[i]['file'],
        // inspectionDate: DateTime.parse(maps[i]['inspectionDate']),
        // lastModifedDate: DateTime.parse(maps[i]['lastModifedDate']),
        data: maps[i]['data'],
      );
    });
  }
}
