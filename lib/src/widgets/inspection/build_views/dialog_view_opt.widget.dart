import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/widgets/inspection/build_views/form_view_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/drop_down_opt.widget.dart';
import 'package:flutter/material.dart';

class DialogViewWidget extends StatelessWidget {
  const DialogViewWidget(
      {super.key,
      required this.data,
      required this.widthSize,
      required this.parentKey,
      required this.formController});

  final Map<String, dynamic> data;
  final double widthSize;
  final String parentKey;
  final FormControllers formController;

  Future<void> showOptionViewDialog(
      BuildContext context, String title, double widthSize) {
    if (!formController.validateDialogViewController(parentKey) ||
        formController.getDialogMap(parentKey)!.isEmpty) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: formController.validateDialogViewController(parentKey)
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

    Map<String, dynamic>? dialogData = formController.getDialogMap(parentKey);
    if (dialogData == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(''),
            content: const Text('No data error'),
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
    // print(dialogData);
    dialogData.remove('Name');
    // print("dialogData $dialogData");
    // need make controller intergrate with formController
    FormControllers tempController = FormControllers();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
              width: widthSize * 0.85,
              child: BuildFormView(
                  field: dialogData,
                  parentKey: parentKey,
                  formController: tempController,
                  widthSize: widthSize * 0.85)),
          actions: [
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                formController.updateDisplayController(
                    tempController.getControllersValue(), parentKey);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogView = <Widget>[];
    String dialogTitle = data['Name']?["Label"] ?? "";
    data.remove('Name');
    formController.addDialogViewController(parentKey);
    dialogView.addAll(
      data.entries.map((entry) {
        final tempFieldData = entry.value as Map<String, dynamic>;
        if (tempFieldData.containsKey("OptionViewName")) {
          String refKey = "${tempFieldData['OptionViewName']['RefKey']}";
          // formController.setDialogForm(tempFieldData, refKey, parentKey);
          formController.setDialogForm(tempFieldData, refKey, parentKey);
          // stop loop
          return Container();
        }
        formController.setDialogSelections(entry.key, parentKey);
        // print("entry: $entry");
        try {
          List<String> options = List<String>.from(tempFieldData['Options']);
          return Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: widthSize * 0.4,
              child: Column(
                children: [
                  Text(
                    tempFieldData['Label'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  DropdownBox(
                      dropdownOpt: options,
                      controller: formController.getDialogSelections(
                          entry.key, parentKey))
                ],
              ),
            ),
          );
        } catch (e) {
          return Text("Error $e");
        }
      }),
    );
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
              controller: formController.getDisplayController(parentKey),
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
