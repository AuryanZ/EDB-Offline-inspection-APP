import 'package:app/src/widgets/inspection/check_box_opt.widget.dart';
import 'package:app/src/widgets/inspection/date_time_picker_opt.widget.dart';
import 'package:app/src/widgets/inspection/drop_down_opt.widget.dart';
import 'package:app/src/widgets/inspection/input_text_opt.widget.dart';
import 'package:flutter/material.dart';

class EntryContainer extends StatefulWidget {
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

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

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

class _EntryContainerState extends State<EntryContainer> {
  List<Map<String, dynamic>> rows = [];

  @override
  void initState() {
    super.initState();
    final sectionView = widget.entry.value['Name']['SectionView'];
    final tableIndex = widget.entry.value['Name']['tableIndex'];
    if (sectionView == "TableView") {
      rows = [Map<String, dynamic>.from(widget.entry.value)..remove('Name')];
      final parentKey = widget.entry.key;

      print(tableIndex);

      for (int i = 0; i <= tableIndex.length; i++) {
        var index = i.toString();
        if (tableIndex.length >= 1) {
          if (i == tableIndex.length) {
            break;
          }
          index = tableIndex[i];
        }
        rows.add(Map<String, dynamic>.from(widget.entry.value)..remove('Name'));
        print('index: $index');
        rows[i].forEach((key, value) {
          try {
            // if (widget.textControllers.keys.contains('$parentKey-$key')) {
            if (value["Type"] == "Text") {
              final newKey = '$parentKey-$index-$key';
              widget.textControllers.remove('$parentKey-$key');
              widget.textControllers[newKey] = TextEditingController();
              print('found');
            } else if (widget.dropdownValues.keys.contains('$parentKey-$key')) {
              final newKey = '$parentKey-$index-$key';
              widget.dropdownValues.remove('$parentKey-$key');
              widget.dropdownValues[newKey] = '';
            } else {
              print('$parentKey-$key not found');
            }
            // }
          } catch (e) {
            print(e);
          }
        });
      }
    }
  }

// Only use for Defualt Table Index Which is "tableIndex": []"
  void addRow() {
    setState(() {
      final newRow = Map<String, dynamic>.from(widget.entry.value)
        ..remove('Name');
      final parentKey = widget.entry.key;
      int newIndex = rows.length;

      newRow.forEach((key, value) {
        if (value['Type'] == 'Text' ||
            value['Type'] == 'Number' ||
            value['Type'] == 'Comment') {
          widget.textControllers['$parentKey-$newIndex-$key'] =
              TextEditingController();
        } else if (value['Type'] == 'Dropdown') {
          widget.dropdownValues['$parentKey-$newIndex-$key'] = '';
        }
      });

      rows.add(newRow);
    });
  }

  Widget buildFieldText(MapEntry<String, dynamic> field, String parentKey,
      {bool labelDisplay = true}) {
    final fieldData = field.value as Map<String, dynamic>;
    final fieldType = fieldData['Type'];
    final fieldLabel = fieldData['Label'];
    final fieldKey = field.key;
    final children = labelDisplay
        ? <Widget>[
            SizedBox(
              child: Text(
                fieldLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ]
        : <Widget>[];

    switch (fieldType) {
      case 'Dropdown':
        final options = List<String>.from(fieldData['Options'] as List);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...children,
              DropdownMenuExample(
                dropdownOpt: options,
                onChanged: (value) {
                  widget.dropdownValues['$parentKey-$fieldKey'] = value!;
                },
              ),
            ],
          ),
        );
      case 'Number':
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              InputBoxOpt(
                label: fieldLabel,
                unit: fieldData['Unit'],
                typeInput: 'number',
                controller: widget.textControllers['$parentKey-$fieldKey']!,
              ),
            ],
          ),
        );
      case 'Text':
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              InputBoxOpt(
                label: fieldLabel,
                unit: '',
                typeInput: 'text',
                controller: widget.textControllers['$parentKey-$fieldKey']!,
              ),
            ],
          ),
        );
      case 'Comment':
        return TextField(
          maxLines: null,
          expands: true,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.start,
          controller: widget.textControllers['$parentKey-$fieldKey']!,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: fieldLabel,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            border: const OutlineInputBorder(),
          ),
        );
      case 'Date':
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              DatePickerExample(
                restorationId: 'main',
                onDateChanged: (newDate) {
                  widget.dateValues['$parentKey-$fieldKey'] = newDate!;
                },
              ),
            ],
          ),
        );
      case 'CheckBox':
        return Center(
          child: CheckBoxOpt(
            titleTxt: fieldLabel,
            onChanged: (value) {
              widget.checkBoxValues['$parentKey-$fieldKey'] = value;
            },
          ),
        );
      default:
        return const Text("Unknown Field Type");
    }
  }

  Widget buildTableView(Map<String, dynamic> field, String parentKey,
      Map<String, dynamic> tableInfo) {
    final headers = <Widget>[
      Container(),
    ];
    // print(tableInfo);
    final expandable = tableInfo['Expandable'];
    final tableIndex = tableInfo['tableIndex'];

    headers.addAll(field.entries.map((entry) {
      if (entry.value is Map<String, dynamic> &&
          entry.value.containsKey('Label')) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            entry.value['Label'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        );
      }
      return const Text('');
    }).toList());
    final tableRows = <TableRow>[TableRow(children: headers)];
    for (int i = 0; i < rows.length; i++) {
      final inputs = <Widget>[
        Text(
          tableIndex.length == 0 ? '${i + 1}' : tableIndex[i],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ];
      inputs.addAll(rows[i].entries.map((entry) {
        if (entry.value is Map<String, dynamic> &&
            entry.value.containsKey('Label')) {
          var keyIndex = i.toString();
          if (tableIndex.length >= 1) {
            keyIndex = tableIndex[i];
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildFieldText(
                MapEntry(entry.key, entry.value), '$parentKey-$keyIndex',
                labelDisplay: false),
          );
        }
        return const Text("Unknown Field Type");
      }).toList());
      tableRows.add(TableRow(children: inputs));
    }
    return SingleChildScrollView(
        child: Column(
      children: [
        Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(50),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: tableRows,
        ),
        expandable
            ? InkWell(
                onTap: () {
                  addRow();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text('Add Row',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ))
            : Container(),
      ],
    ));
  }

  Widget buildFormView(
      Map<String, dynamic> field, String parentKey, double widthSize) {
    final widgets = <Widget>[];
    for (int i = 0; i < field.entries.length; i += 2) {
      final children = <Widget>[];
      final firstField = field.entries.elementAt(i);
      if (firstField.value['Type'] == 'Comment') {
        children.add(SizedBox(
            width: widthSize * 0.85,
            height: 200,
            child: buildFieldText(firstField, parentKey)));
      } else {
        children.add(
            buildContainer(buildFieldText(firstField, parentKey), widthSize));
        if (i + 1 < field.entries.length &&
            field.entries.elementAt(i + 1).value['Type'] != 'Comment') {
          children.add(buildContainer(
              buildFieldText(field.entries.elementAt(i + 1), parentKey),
              widthSize));
        } else {
          i--;
          children.add(
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              width: widthSize * 0.4,
              alignment: Alignment.centerLeft,
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
    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Map<String, dynamic>.from(widget.entry.value);
    final subTitle = data['Name']['Label'];
    final alert = data['Name']['Alert'];
    final hint = data['Name']['Hint'];
    final sectionView = data['Name']['SectionView'];
    // print(sectionView);
    final widgets = <Widget>[];
    final widthSize = MediaQuery.of(context).size.width;
    final parentKey = widget.entry.key;
    if (sectionView == "TableView") {
      final Map<String, dynamic> tableInfo = {
        'Expandable': data['Name']['Expandable'],
        'tableIndex': data['Name']['tableIndex']
      };
      data.remove('Name');
      // print(tableInfo);
      widgets.add(SizedBox(
          width: widthSize * 0.85,
          // height: 200,
          child: buildTableView(data, parentKey, tableInfo)));
    } else {
      data.remove('Name');
      widgets.add(buildFormView(data, parentKey, widthSize));
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              if (hint != '')
                Tooltip(
                  message: hint,
                  child: const Icon(
                    Icons.help_outline,
                    size: 18.0,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          Text(
            alert,
            style: const TextStyle(color: Colors.red, fontSize: 15),
          ),
          ...widgets,
        ],
      ),
    );
  }
}
