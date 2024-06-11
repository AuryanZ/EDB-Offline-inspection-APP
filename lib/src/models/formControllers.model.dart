import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormControllers {
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, String> dropdownValues = {};
  final Map<String, DateTime> dateValues = {};
  final Map<String, bool> checkBoxValues = {};
  final List<Map<String, dynamic>> autoFillControllers = [];

  FormControllers();

  void setTextController(String key, TextEditingController value) {
    if (textControllers[key] == null) {
      textControllers[key] = value;
    }
  }

  // get controller for a text field
  TextEditingController getTextController(String key) {
    return textControllers[key]!;
  }

  void setDropdownValue(String key, String value) {
    if (dropdownValues[key] != value && value != "") {
      dropdownValues[key] = value;
    } else {
      dropdownValues[key] = "";
    }
  }

  String getDropdownValue(String key) {
    return dropdownValues[key]!;
  }

  void setDateValue(String key, DateTime value) {
    dateValues[key] = value;
  }

  DateTime getDateValue(String key) {
    return dateValues[key]!;
  }

  void setCheckBoxValue(String key, bool value) {
    checkBoxValues[key] = value;
  }

  bool getCheckBoxValue(String key) {
    return checkBoxValues[key]!;
  }

  void addTableController(
      Map<String, dynamic> row, String parentKey, String index) {
    row.forEach((key, value) {
      try {
        final newKey = '$parentKey-$index-$key';
        if (value["Type"] == "Text") {
          textControllers.remove('$parentKey-$key');
          textControllers[newKey] = TextEditingController();
        } else if (value["Type"] == "Dropdown") {
          dropdownValues.remove('$parentKey-$key');
          dropdownValues[newKey] = '';
        } else if (value["Type"] == "Date") {
          dateValues.remove('$parentKey-$key');
          dateValues[newKey] = DateTime.now();
        } else if (value["Type"] == "CheckBox") {
          checkBoxValues.remove('$parentKey-$key');
          checkBoxValues[newKey] = false;
        } else {
          // print('$parentKey-$key not found');
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
    data.addAll(dropdownValues);
    data.addAll(dateValues);
    data.addAll(checkBoxValues);
    var sortedData = SplayTreeMap<String, dynamic>.from(data);
    return sortedData;
  }

  void addAutoFillController(String tableName, String columnName, String refKey,
      String controllerKey, String controllerType) {
    switch (controllerType) {
      case 'Text':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from({
            'tableName': tableName,
            'columnName': columnName,
            'controller': textControllers[controllerKey]
          })
        });
      case 'Dropdown':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from({
            'tableName': tableName,
            'columnName': columnName,
            'controller': dropdownValues[controllerKey]
          })
        });
      case 'Date':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from({
            'tableName': tableName,
            'columnName': columnName,
            'controller': dateValues[controllerKey]
          })
        });
      case 'CheckBox':
        autoFillControllers.add({
          refKey: Map<String, dynamic>.from({
            'tableName': tableName,
            'columnName': columnName,
            'controller': checkBoxValues[controllerKey]
          })
        });
    }
  }
}
