import 'package:app/src/data/formControllers.data.dart';
import 'package:flutter/material.dart';

class DialogViewWidget extends StatefulWidget {
  const DialogViewWidget(
      {super.key,
      required this.data,
      required this.widthSize,
      required this.formController});

  final Map<String, dynamic> data;
  final double widthSize;
  final FormControllers formController;

  @override
  State<DialogViewWidget> createState() => _DialogViewWidget();
}

class _DialogViewWidget extends State<DialogViewWidget> {
  Map<String, dynamic> data = {};
  double widthSize = 0.0;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    widthSize = widget.widthSize;
  }

  Future<void> showOptionViewDialog(
      BuildContext context, String title, double widthSize) {
    if (!widget.formController.validateDialogViewController() ||
        widget.formController.getDialogMap().isEmpty) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: widget.formController.validateDialogViewController()
                ? const Text('No data error')
                : const Text("Please fill all required fields."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    Map<String, dynamic> dialogData = widget.formController.getDialogMap();
    dialogData.remove('Name');
    // print("dialogData $dialogData");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
              width: widthSize * 0.85,
              // height: 200,
              // child: buildFormView(dialogData, "", widthSize * 0.85)),
              child: const Text("aaaa")),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController displayController = TextEditingController();
    final dialogView = <Widget>[];
    String dialogTitle = data['Name']?["Label"] ?? "";
    data.remove('Name');
    for (int i = 0; i < data.length; i++) {
      final key = data.keys.elementAt(i);
      final value = data[key];
      // print("key: $key, value: $value");
    }
    // print(data);

    dialogView.add(ElevatedButton(
      onPressed: () {
        showOptionViewDialog(context, dialogTitle, widthSize);
      },
      child: const Text("Add"),
    ));

    dialogView.add(Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 8.0),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: SizedBox(
            width: widthSize * 0.85,
            height: 200,
            child: TextField(
              maxLines: null,
              readOnly: true,
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.start,
              controller: displayController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                alignLabelWithHint: true,
                labelText: "Work Done",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ))));

    return Column(
      children: dialogView,
    );
  }
}
