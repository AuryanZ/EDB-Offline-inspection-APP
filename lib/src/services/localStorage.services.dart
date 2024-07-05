import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  final String fileName;
  final String dir;
  final String data;

  LocalStorageService(
      {required this.fileName, required this.dir, required this.data});

  Future<File> _getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(
        "${directory.parent.parent.path}\\The Lines Company\\Asset Information and Data - Inspection App\\TestingFolder\\$dir\\$fileName.json");
  }

  void saveData() async {
    final file = await _getDir();
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    file.writeAsString(json.encode(data));
  }
}
