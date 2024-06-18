import 'dart:collection';

import 'package:app/src/services/autFillDB.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormControllers {
  final Map<String, TextEditingController> textControllers = {};
  // final Map<String, String> dropdownValues = {};
  final Map<String, DateTime> dateValues = {};
  final Map<String, bool> checkBoxValues = {};
  final List<Map<String, dynamic>> autoFillControllers = [];

  void _addAutoFillController(String tableName, String columnName,
      String refKey, String controllerKey, String controllerType) {
    switch (controllerType) {
      case 'Text':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from(
              {'tableName': tableName, 'columnName': columnName}),
          controllerKey: textControllers[controllerKey]
        });
        break;
      case 'Dropdown':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from(
              {'tableName': tableName, 'columnName': columnName}),
          controllerKey: textControllers[controllerKey]
        });
        break;
      case 'Date':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from(
              {'tableName': tableName, 'columnName': columnName}),
          controllerKey: dateValues[controllerKey]
        });
        break;
      case 'CheckBox':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from(
              {'tableName': tableName, 'columnName': columnName}),
          controllerKey: checkBoxValues[controllerKey]
        });
        break;
    }
  }

  void processAutoFill(String refKey, String value) {
    // find all refKey in autoFillControllers
    final controllers = autoFillControllers
        .where((element) => element.containsKey(refKey))
        .toList();

    final db = AutoFillDbServices();

    for (var element in controllers) {
      String tableName = element[refKey]['tableName'];
      String columnName = element[refKey]['columnName'];
      String controllerKey = element.keys.last;
      String? data;
      db.getData(tableName, columnName, value, refKey).then((dbvalue) {
        data = dbvalue.toString();
        textControllers[controllerKey]!.text = data!;
        // print(dbvalue);
      });
    }
  }

  FormControllers();

  void setTextController(String key, TextEditingController value,
      {String? tableName, String? columnName, String? refKey}) {
    if (textControllers[key] == null) {
      textControllers[key] = value;
      // print("setTextController: \nkey: $key TableName: $tableName");
      tableName != null && columnName != null && refKey != null
          ? _addAutoFillController(tableName, columnName, refKey, key, 'Text')
          : null;
    }
  }

  // void updateTexeController(String key, String value) {
  //   textControllers[key]!.text = value;
  // }

  TextEditingController getTextController(String key) {
    // print("objectKey: $key, objectValue: ${textControllers[key]!.text}");
    return textControllers[key]!;
  }

  // void setDropdownValue(String key, String value,
  //     {String? tableName, String? columnName, String? refKey}) {
  //   if (dropdownValues[key] != value && value != "") {
  //     dropdownValues[key] = value;
  //     if (columnName == refKey &&
  //         _dbInfoNotNullCheck(tableName, columnName, refKey)) {
  //       print("process auto fill");
  //       _processAutoFill(refKey!, value);
  //     }
  //   } else {
  //     dropdownValues[key] = "";
  //     _dbInfoNotNullCheck(tableName, columnName, refKey)
  //         ? _addAutoFillController(
  //             tableName!, columnName!, refKey!, key, 'Dropdown')
  //         : null;
  //     // tableName != null && columnName != null && refKey != null
  //     //     ? _addAutoFillController(tableName, columnName, refKey, key, 'Text')
  //     //     : null;
  //   }
  // }

  // String getDropdownValue(String key) {
  //   return dropdownValues[key]!;
  // }

  void setDateValue(String key, DateTime value,
      {String? tableName, String? columnName, String? refKey}) {
    dateValues[key] = value;
    tableName != null && columnName != null && refKey != null
        ? _addAutoFillController(tableName, columnName, refKey, key, 'Date')
        : null;
  }

  DateTime getDateValue(String key) {
    return dateValues[key]!;
  }

  void setCheckBoxValue(String key, bool value,
      {String? tableName, String? columnName, String? refKey}) {
    checkBoxValues[key] = value;
    tableName != null && columnName != null && refKey != null
        ? _addAutoFillController(tableName, columnName, refKey, key, 'CheckBox')
        : null;
  }

  bool getCheckBoxValue(String key) {
    return checkBoxValues[key]!;
  }

  void addTableController(
      Map<String, dynamic> row, String parentKey, String index) {
    row.forEach((key, value) {
      String? dbTableName = value["DBTableName"];
      String? dbColumnName = value["DBColumnName"];
      String? refKey = value["RefKey"];
      try {
        final newKey = '$parentKey-$index-$key';
        if (value["Type"] == "Text" || value["Type"] == "Dropdown") {
          setTextController(newKey, TextEditingController(),
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
          // } else if (value["Type"] == "Dropdown") {
          //   setDropdownValue(newKey, '',
          //       tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else if (value["Type"] == "Date") {
          setDateValue(newKey, DateTime.now(),
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else if (value["Type"] == "CheckBox") {
          setCheckBoxValue(newKey, false,
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else {
          throw FormatException(
              "Error: \n Form template with $newKey has unknow type.");
        }
      } catch (e) {
        throw FormatException(
            'Error in adding table controller. \n Message: $e');
      }
    });
  }

  Map<String, dynamic> getControllersValue() {
    Map<String, dynamic> data = {};
    data.addAll(textControllers.map((key, value) => MapEntry(key, value.text)));
    // data.addAll(dropdownValues);
    data.addAll(dateValues);
    data.addAll(checkBoxValues);
    var sortedData = SplayTreeMap<String, dynamic>.from(data);
    return sortedData;
  }
}
