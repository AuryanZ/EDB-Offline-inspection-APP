import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/widgets/inspection/components/components_controller.widget.dart';
import 'package:flutter/material.dart';

class BuildFormView extends StatelessWidget {
  final Map<String, dynamic> field;
  final String parentKey;
  final double widthSize;
  final FormControllers formController;

  const BuildFormView(
      {super.key,
      required this.field,
      required this.parentKey,
      required this.formController,
      required this.widthSize});

/* build a empty container for odd number of items in section to lock UI space */
  Widget buildContainer(Widget child, double widthSize) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widthSize * 0.4,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];

    for (int i = 0; i < field.entries.length; i += 2) {
      final children = <Widget>[];
      final firstField = field.entries.elementAt(i);
      if (firstField.value['Type'] == 'Comment') {
        children.add(SizedBox(
            width: widthSize * 0.85,
            height: 200,
            child: BuildFields(
              field: firstField,
              parentKey: parentKey,
              formController: formController,
            )));
      } else {
        children.add(buildContainer(
            BuildFields(
                field: firstField,
                parentKey: parentKey,
                formController: formController),
            widthSize));
        if (i + 1 < field.entries.length &&
            field.entries.elementAt(i + 1).value['Type'] != 'Comment') {
          children.add(buildContainer(
              BuildFields(
                field: field.entries.elementAt(i + 1),
                parentKey: parentKey,
                formController: formController,
              ),
              widthSize));
        } else {
          i--;
          children.add(buildContainer(const Text(""), widthSize));
        }
      }

      widgets.add(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      );
    }

    return Column(children: widgets);
  }
}
