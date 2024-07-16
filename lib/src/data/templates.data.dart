import 'dart:convert';
import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/models/inspections.model.dart';
import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/services/localStorage.services.dart';
import 'package:app/src/widgets/inspection/form_generator.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      // print("assets/form_temp/$formName/$form");
      return await rootBundle.loadString('assets/form_temp/$formName/$form');
    } catch (e) {
      // print(e);
      return '{"Title": "Template Not Found"}';
    }
  }

  void setData(String data) {
    inspectionForm = json.decode(data);
    try {
      title = inspectionForm['Title']['Title'];
      namingConvention = inspectionForm['Title']['NamingConvention'];
    } catch (e) {
      title = "Template Not Found";
      namingConvention = "Template Not Found";
    }
    inspectionForm.remove('Title');
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
    Map<String, dynamic> data = formController.getControllersValue();
    Map<String, dynamic> saveData = {};
    inspectionForm.forEach((key, value) {
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

    List<String> fileNaming = namingConvention.split("-");
    String workNumber = "${saveData[fileNaming[0]][fileNaming[1]]}";
    String msg = "";
    bool recordStatus = false;
    if (workNumber.isEmpty) {
      return Map<String, dynamic>.from({
        "state": 400,
        "msg": Text(
            "Failed! ${inspectionForm[fileNaming[0]][fileNaming[1]]["Label"]} is required",
            style: const TextStyle(color: Colors.red))
      });
    }
    String fileName = "$title ${fileNaming[1]}-$workNumber";

    try {
      // await platform
      await LocalStorageService(
              fileName: fileName, data: json.encode(saveData), dir: "test")
          .saveData()
          .then((value) {
        if (value) {
          recordStatus = true;
          msg += "Data synced to online storage \n";
        } else {
          throw "Data not synced, Please manually update \n";
        }
      });
    } catch (e) {
      msg += "${e.toString()} \n";
    }

    try {
      final inspectionDb = InspectionRecordDB();
      Inspections inspection = Inspections(
          name: title,
          status: recordStatus,
          codeKey: fileNaming[1],
          code: workNumber,
          inspectionDate: DateTime.now(),
          lastModifedDate: DateTime.now(),
          file: fileName,
          data: json.encode(saveData));
      await inspectionDb.insertInspection(inspection);
      msg += "Data saved to local storage \n";
    } catch (e) {
      return Map<String, dynamic>.from(
          {"state": 400, "msg": Text("Error: $e")});
    }

    return Map<String, dynamic>.from({"state": 200, "msg": Text(msg)});
  }
}
