import 'dart:convert';
// import 'dart:io';
import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/models/inspections.model.dart';
import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/services/localStorage.services.dart';
import 'package:app/src/widgets/inspection/form_generator.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

class Templates {
  String inspectionName = '';
  Map<String, dynamic> inspectionForm = {};
  String title = '';
  String namingConvention = '';

  FormControllers formController = FormControllers();

  Templates();

  bool get isLoaded => inspectionForm.isNotEmpty;

  void dispose() {
    formController.dispose();
    inspectionName = '';
    inspectionForm.clear();
    title = '';
  }

  Future<String> loadForm(String formName) async {
    String form = "${formName.replaceAll(" ", "_").toLowerCase()}.dataFormTemp";
    inspectionName = formName;
    try {
      return await rootBundle.loadString('assets/form_temp/$form');
    } catch (e) {
      return '{"Title": "Template Not Found"}';
    }
  }

  void setData(String data) {
    inspectionForm = json.decode(data);
    title = inspectionForm['Title']['Title'];
    namingConvention = inspectionForm['Title']['NamingConvention'];
    // print("Title ${inspectionForm['Title']} \n");
    inspectionForm.remove('Title');
    // print(data);
  }

  List<Widget> getInpectSections() {
    final children = <Widget>[];
    for (var entry in inspectionForm.entries) {
      // print("entry: $entry \n");
      children.add(EntryContainer(
        entry: entry,
        formController: formController,
      ));
    }
    return children;
  }

  Future<Map<String, dynamic>> saveInspection() async {
    // Future.delayed(
    //   const Duration(seconds: 2),
    // );
    Map<String, dynamic> data = formController.getControllersValue();
    // print(data);
    Map<String, dynamic> saveData = {};
    inspectionForm.forEach((key, value) {
      // print("${data[key]} \n");
      // print("${value["Name"]["SectionView"]} \n");
      if (saveData[key] == null) {
        saveData[key] = Map<String, dynamic>.from({
          "data info": {
            "Label": value["Name"]["Label"],
            "SectionView": value["Name"]["SectionView"],
            "TableIndex": value["Name"]["SectionView"] == "TableView"
                ? data[key]["formIndex"]
                : "",
          }
        });
      }
      if (value["Name"]["SectionView"] == "TableView") {
        data[key]["formIndex"].forEach((index) {
          saveData[key]["$index"] = {};
          value.forEach((key2, value2) {
            if (key2 != "Name") {
              saveData[key]["$index"][key2] = data[key]["$key2-$index"];
            }
          });
        });
      } else {
        value.forEach((key2, value2) {
          if (key2 != "Name") {
            saveData[key][key2] = data[key][key2];
          }
        });
      }
    });

    // print(saveData);
    List<String> fileNaming = namingConvention.split("-");
    String workNumber = "${saveData[fileNaming[0]][fileNaming[1]]}";
    // print(namingConvention);
    if (workNumber.isEmpty) {
      return Map<String, dynamic>.from({
        "state": 400,
        "msg": Text(
            "Failed! ${inspectionForm[fileNaming[0]][fileNaming[1]]["Label"]} is required",
            style: const TextStyle(color: Colors.red))
      });
    }
    String fileName = "$title ${fileNaming[1]}-$workNumber";
    // print(fileName);

    final inspectionDb = InspectionRecordDB();

    try {
      Inspections inspection = Inspections(
          name: title,
          status: false,
          codeKey: fileNaming[1],
          code: workNumber,
          inspectionDate: DateTime.now(),
          lastModifedDate: DateTime.now(),
          file: fileName,
          data: json.encode(saveData));
      await inspectionDb.database.then((db) {
        db.insert('Inspections', inspection.toMap());
      });

      // XFile file = XFile(
      //     "C:/Users/Rui.Zeng/The Lines Company/Asset Information and Data - Inspection App/TestingFolder");
      // final directory = await getApplicationDocumentsDirectory();
      // print(
      //     "${directory.parent.path}\\The Lines Company\\Asset Information and Data - Inspection App\\TestingFolder");

      // // await directory.create(recursive: true);
      // File file = File(
      //     "${directory.parent.parent.path}\\The Lines Company\\Asset Information and Data - Inspection App\\TestingFolder\\$fileName.json");
      // if (!file.existsSync()) {
      //   file.createSync(recursive: true);
      // }

      // file.writeAsString(json.encode(saveData));

      // await platform
      LocalStorageService(
              fileName: fileName, data: json.encode(saveData), dir: "test")
          .saveData();
    } catch (e) {
      return Map<String, dynamic>.from(
          {"state": 400, "msg": Text("Error: $e")});
    }

    return Map<String, dynamic>.from(
        {"state": 200, "msg": Text("Data Saved in $fileName")});
  }
}
