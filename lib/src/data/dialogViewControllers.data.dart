class DialogViewController {
  List<String> dialogViewKeys = [];
  Map<String, dynamic> dialogForm = {};
  String dialogRefwKey = '';
  DialogViewController();

  void dispose() {
    dialogForm.clear();
    dialogViewKeys.clear();
    dialogRefwKey = '';
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
}
