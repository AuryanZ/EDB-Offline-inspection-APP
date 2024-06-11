import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AutoFillDbServices {
  static const String dbName = 'autoFill.db';

  Future<Database> getDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final exist = await databaseExists(path);
    if (!exist) {
      try {
        await Directory(dbPath).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/", "autoFill.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>?> getTable(String tableName) async {
    final db = await getDB();
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Map<String, dynamic>> data = [];
    List.generate(maps.length, (index) {
      return data.add(maps[index]);
    });

    return data;
  }

  Future<List<dynamic>> getColumn(String tableName, String columnName) async {
    final db = await getDB();
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<dynamic> data = [];
    List.generate(maps.length, (index) {
      // print(maps[index][columnName]);
      return data.add(maps[index][columnName]);
    });

    return data;
  }
}
