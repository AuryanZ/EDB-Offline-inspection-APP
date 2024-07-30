import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  final String fileName;
  final String dir;
  final String dataJsonString;

  LocalStorageService(
      {required this.fileName,
      required this.dir,
      required this.dataJsonString});

  Future<File?> _getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    if (File(
            "${directory.parent.parent.path}\\The Lines Company\\Asset Information and Data - Inspection App\\TestingFolder\\$dir")
        .existsSync()) {
      return null;
    }
    return File(
        "${directory.parent.parent.path}\\The Lines Company\\Asset Information and Data - Inspection App\\TestingFolder\\$dir\\$fileName.json");
  }

  Future<bool> saveData() async {
    final file = await _getDir();
    if (file == null) {
      return false;
    }
    if (!file.existsSync()) {
      try {
        file.createSync(recursive: true);
      } catch (e) {
        throw "failed to create file $e \n";
      }
      // return false;
    }

    file.writeAsString(dataJsonString);
    return true;
  }
}
