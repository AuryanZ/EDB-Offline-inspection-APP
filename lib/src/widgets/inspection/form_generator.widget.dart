import 'package:app/src/widgets/inspection/check_box_opt.widget.dart';
import 'package:app/src/widgets/inspection/date_time_picker_opt.widget.dart';
import 'package:app/src/widgets/inspection/drop_down_opt.widget.dart';
import 'package:app/src/widgets/inspection/input_text_opt.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryContainer extends StatelessWidget {
  final MapEntry<String, dynamic> entry;
  final Map<String, TextEditingController> textControllers;
  final Map<String, String> dropdownValues;
  final Map<String, DateTime> dateValues;
  final Map<String, bool> checkBoxValues;

  const EntryContainer(
      {super.key,
      required this.entry,
      required this.textControllers,
      required this.dropdownValues,
      required this.dateValues,
      required this.checkBoxValues});

  Widget buildFieldText(MapEntry<String, dynamic> field, String parrentKey) {
    Map<String, dynamic> fieldData = field.value;

    if (fieldData['Type'] == 'Dropdown') {
      List<String> options = (fieldData['Options'] as List<dynamic>)
          .map((item) => item.toString())
          .toList();
      return Center(
          child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          DropdownMenuExample(
            dropdownOpt: options,
            onChanged: (value) {
              dropdownValues['$parrentKey-${field.key}'] = value!;
            },
          ),
        ],
      ));
    } else if (fieldData['Type'] == "Number") {
      return Center(
          child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          InputBoxOpt(
            // label: '${fieldData['Label']} (Unit in ${fieldData['Unit']})',
            label: fieldData['Label'],
            unit: fieldData['Unit'],
            typeInput: 'number',
            controller: textControllers['$parrentKey-${field.key}']!,
          )
        ],
      ));
    } else if (fieldData['Type'] == 'Text') {
      return Center(
          child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          InputBoxOpt(
            label: fieldData['Label'],
            unit: '',
            typeInput: 'text',
            controller: textControllers['$parrentKey-${field.key}']!,
          )
        ],
      ));
    } else if (fieldData['Type'] == 'Comment') {
      //not used
      return SizedBox(
        // width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        child: TextField(
          maxLines: null,
          expands: true,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.start,
          controller: textControllers['$parrentKey-${field.key}']!,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: fieldData['Label'],
            // border: OutlineInputBorder(),
          ),
        ),
      );
    } else if (fieldData['Type'] == 'Date') {
      return Center(
          child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          DatePickerExample(
            restorationId: 'main',
            onDateChanged: (newDate) {
              dateValues['$parrentKey-${field.key}'] = newDate!;
            },
          ),
        ],
      ));
    } else if (fieldData['Type'] == 'CheckBox') {
      return Center(
          child: CheckBoxOpt(
        titleTxt: fieldData['Label'],
        onChanged: (value) {
          checkBoxValues['$parrentKey-${field.key}'] = value;
        },
      ));
    } else {
      return const Text("Unknown Field Type");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
    final subTitle = data['Name'];
    data.remove('Name');
    // print(entry.key);
    final widgets = <Widget>[];

    for (int i = 0; i < data.entries.length; i += 2) {
      final children = <Widget>[];
      if (data.entries.elementAt(i).value['Type'] == 'Comment') {
        children.add(SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 200,
          child: TextField(
            maxLines: null,
            expands: true,
            controller: textControllers['${entry.key}-Comments']!,
            keyboardType: TextInputType.multiline,
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              labelText: "COMMENT",
              border: OutlineInputBorder(),
            ),
          ),
        ));
      } else {
        children.add(Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: buildFieldText(data.entries.elementAt(i), entry.key),
          ),
        ));
        if (i + 1 < data.entries.length) {
          children.add(
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: buildFieldText(data.entries.elementAt(i + 1), entry.key),
              ),
            ),
          );
        } else {
          children.add(
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.4,
              height: 50,
              color: Colors.transparent,
            ),
          );
        }
      }

      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            subTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          ...widgets,
        ],
      ),
    );
  }
}
