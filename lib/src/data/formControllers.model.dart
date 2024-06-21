import 'dart:collection';
import 'dart:io';

import 'package:app/src/services/autFillDB.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormControllers {
  final Map<String, TextEditingController> textControllers = {};
  // final Map<String, String> dropdownValues = {};
  final Map<String, DateTime> dateValues = {};
  final Map<String, bool> checkBoxValues = {};
  final List<Map<String, dynamic>> autoFillControllers = [];
  final List<File> imageList = [];
  final Map<String, List<File>> imageListControllers = {};

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
      tableName != null && columnName != null && refKey != null
          ? _addAutoFillController(tableName, columnName, refKey, key, 'Text')
          : null;
    }
  }

  TextEditingController getTextController(String key) {
    return textControllers[key]!;
  }

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

  void setImageListController(String key, List<File> value) {
    if (imageListControllers[key] == null) {
      imageListControllers[key] = value;
    }
  }

  List<File> getImageListController(String key) {
    return imageListControllers[key]!;
  }

  void addTableController(
      Map<String, dynamic> row, String parentKey, String index) {
    row.forEach((key, value) {
      String? dbTableName = value["DBTableName"];
      String? dbColumnName = value["DBColumnName"];
      String? refKey = value["RefKey"];
      String? valueType = value["Type"];
      if (valueType == null || valueType == "") {
        throw FormatException("Error: \n Form template with $key has no type.");
      }
      try {
        final newKey = '$parentKey-$index-$key';
        if (valueType.toLowerCase() == "text" ||
            valueType.toLowerCase() == "dropdown" ||
            valueType.toLowerCase() == "number" ||
            valueType.toLowerCase() == "comment") {
          setTextController(newKey, TextEditingController(),
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else if (valueType.toLowerCase() == "date") {
          setDateValue(newKey, DateTime.now(),
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else if (valueType.toLowerCase() == "checkbox") {
          setCheckBoxValue(newKey, false,
              tableName: dbTableName, columnName: dbColumnName, refKey: refKey);
        } else if (valueType.toLowerCase() == "images") {
          setImageListController("img-$newKey", []);
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
    data.addAll(dateValues);
    data.addAll(checkBoxValues);
    data.addAll(imageListControllers);
    var sortedData = SplayTreeMap<String, dynamic>.from(data);
    return sortedData;
  }
}
