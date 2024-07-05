import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class InspectionExecute {
  Future<void> createTable(Database db) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS Inspections (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        codeKey TEXT NOT NULL,
        code TEXT NOT NULL,
        status INTEGER NOT NULL,
        inspectionDate TEXT NOT NULL,
        lastModifedDate TEXT NOT NULL,
        file TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }
}
