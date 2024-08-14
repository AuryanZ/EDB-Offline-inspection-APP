import 'dart:convert';
import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/models/inspections.model.dart';
import 'package:app/src/services/autFillDB.services.dart';
import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/services/localStorage.services.dart';
import 'package:app/src/widgets/inspection/form_generator.widget.dart';
import 'package:flutter/material.dart';

class Templates {
  List<String> inspectionNames = [];
  String inspectionName = '';
  Map<String, dynamic> inspectionForm = {};
  String title = '';
  String namingConvention = '';

  FormControllers formController = FormControllers();

  Templates();

  bool get isLoaded => inspectionForm.isNotEmpty;

  void dispose() {
    formController.dispose();
    inspectionNames.clear();
    inspectionName = '';
    inspectionForm.clear();
    title = '';
  }

  String _capitalizeFirstLetterOfEachWord(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Future<String> setInspectionNames() async {
    AutoFillDbServices buttonDb = AutoFillDbServices();
    await buttonDb
        .getTable("workTemplates")
        .then((value) => value?.forEach((element) {
              inspectionNames
                  .add(_capitalizeFirstLetterOfEachWord(element["name"]));
            }));
    inspectionNames.sort();
    buttonDb.dispose();
    if (inspectionNames.isEmpty) {
      return Future.value("No names set");
    }

    return Future.value("Names set");
  }

  // get inspection names
  List<String> getInspectionNames() {
    return inspectionNames;
  }

  Future<String> loadForm(String formName) async {
    // await Future.delayed(const Duration(seconds: 5));
    AutoFillDbServices formDb = AutoFillDbServices();
    inspectionName = formName;

    String data;
    try {
      data = await formDb.getData(
          "workTemplates", "template", formName.toLowerCase(), "name");
    } catch (e) {
      data = '{"Title": "Template Not Found"}';
    }

    if (formName == "Zone Sub Inspection") {
      return data;
    }
    _setData(data);

    return '{"Title": "Load Form Completed"}';
  }

  void _setData(String data) {
    inspectionForm = json.decode(data);
    try {
      title = inspectionForm['Title']['Title'];
      namingConvention = inspectionForm['Title']['NamingConvention'];
      inspectionForm.remove('Title');
    } catch (e) {
      title = "Template Not Found";
      namingConvention = "Template not Found";
      inspectionForm = {};
    }
  }

  List<Widget> getInpectSections() {
    final children = <Widget>[];
    // print(inspectionForm);
    for (var entry in inspectionForm.entries) {
      // print("entry: $entry \n");
      children.add(EntryContainer(
        entry: entry,
        formController: formController,
      ));
    }

    return children;
  }

  Map<String, dynamic> _processSaveData(
      Map<String, dynamic> inputData, Map<String, dynamic> inspectionForm) {
    // Map<String, dynamic> data = formController.getControllersValue();
    // print("data: $data");
    Map<String, dynamic> resultData = {};

    inspectionForm.forEach((formSectionName, formSectionValue) {
      if (formSectionName != "Name") {
        if (resultData[formSectionName] == null) {
          resultData[formSectionName] = Map<String, dynamic>.from({
            "data info": {
              "Label": formSectionValue["Name"]["Label"],
              "SectionView": formSectionValue["Name"]["SectionView"],
              "TableIndex":
                  formSectionValue["Name"]["SectionView"] == "TableView"
                      ? inputData[formSectionName]["formIndex"]
                      : "",
            }
          });
        }
        if (formSectionValue["Name"]?["SectionView"] == "TableView") {
          inputData[formSectionName]["formIndex"].forEach((tableIndex) {
            resultData[formSectionName]["$tableIndex"] = {};
            formSectionValue.forEach((taskName, taskValue) {
              if (taskName != "Name") {
                resultData[formSectionName]["$tableIndex"][taskName] =
                    inputData[formSectionName]["$taskName-$tableIndex"];
              }
            });
          });
        } else if (formSectionValue["Name"]["SectionView"] == "SubFormView") {
          // print("key: $key , value: $value");
          resultData[formSectionName]
              .addAll(_processSaveData(inputData, formSectionValue));
        } else if (formSectionValue["Name"]["SectionView"] == "OptionView") {
          // print("key: $key , value: $value");
          inputData[formSectionName]["formIndex"].forEach((index) {
            resultData[formSectionName]["$index"] = {};
            formSectionValue.forEach((taskName, taskValue) {
              if (taskValue.containsKey("OptionViewName")) {
                // get [OptionViewName][RefKey] value
                String refKey = taskValue['OptionViewName']['RefKey'];
                String optViewKey =
                    resultData[formSectionName]["$index"][refKey];
                // print("refKey: $refKey");
                // print("key: $optViewKey");
                // print("taskValue: ${taskValue[optViewKey]}");
                taskValue[optViewKey].forEach((key3, value3) {
                  // ignore OptionViewName section
                  if (key3 != "Name") {
                    resultData[formSectionName]["$index"][key3] =
                        inputData[formSectionName]["$key3-$index"];
                  }
                });
              } else {
                if (taskName != "Name") {
                  resultData[formSectionName]["$index"][taskName] =
                      inputData[formSectionName]["$taskName-$index"];
                }
              }
            });
          });
        } else {
          formSectionValue.forEach((taskName, taskValue) {
            if (taskName != "Name") {
              resultData[formSectionName][taskName] =
                  inputData[formSectionName][taskName];
            }
          });
        }
      }
    });

    return resultData;
  }

  Future<Map<String, dynamic>> saveInspection() async {
    Map<String, dynamic> saveData;
    try {
      saveData = _processSaveData(
          formController.getControllersValue(), inspectionForm);
    } catch (e) {
      return Map<String, dynamic>.from(
          {"state": 400, "msg": Text("Error: $e")});
    }
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
              fileName: fileName,
              dataJsonString: jsonEncode(saveData),
              dir: "test")
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
