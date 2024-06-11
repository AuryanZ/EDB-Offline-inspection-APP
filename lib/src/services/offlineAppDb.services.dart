import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class OfflineAppDb {
  Future<void> createTable(Database db) {
    return db.execute('''
      CREATE TABLE IF NOT EXISTS Inspections (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        inspectionDate TEXT NOT NULL,
        lastModifedDate TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }
}
