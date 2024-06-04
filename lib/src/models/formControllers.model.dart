import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormControllers {
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, String> dropdownValues = {};
  final Map<String, DateTime> dateValues = {};
  final Map<String, bool> checkBoxValues = {};

  FormControllers();

  void setTextController(String key, TextEditingController value) {
    textControllers[key] = value;
  }

  // get controller for a text field
  TextEditingController getTextController(String key) {
    return textControllers[key]!;
  }

  void setDropdownValue(String key, String value) {
    dropdownValues[key] = value;
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
}
