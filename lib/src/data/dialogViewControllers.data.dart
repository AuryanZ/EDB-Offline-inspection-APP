import 'package:flutter/material.dart';

class DialogViewController {
  List<String> dialogViewKeys = [];
  Map<String, dynamic> dialogForm = {};
  String dialogRefwKey = '';
  Map<String, TextEditingController> dialogSelections = {};
  TextEditingController displayController = TextEditingController();
  int index = 0;
  DialogViewController();

  void dispose() {
    dialogForm.clear();
    dialogViewKeys.clear();
    dialogRefwKey = '';
  }

  void addIndex() {
    index++;
  }

  String getIndex() {
    return index.toString();
  }

  void setDialogViewKeys(String key) {
    dialogViewKeys.add(key);
  }

  List<String> getDialogViewKeys() {
    return dialogViewKeys;
  }

  void setDialogForm(Map<String, dynamic> dialogForm, String dialogRefwKey) {
    this.dialogForm = dialogForm;
    this.dialogRefwKey = dialogRefwKey;
  }

  String getDialogRefwKey() {
    return dialogRefwKey;
  }

  Map<String, dynamic> getDialogFormByKey(String key) {
    try {
      // print(dialogForm[key]);
      return dialogForm[key];
    } catch (e) {
      return {};
    }
  }

  void setDialogSelections(String key) {
    // if (dialogSelections[key] == null) {
    dialogSelections[key] = TextEditingController();
    // }
  }

  void updateDisplayController(String value) {
    displayController.text += value;
  }
}
