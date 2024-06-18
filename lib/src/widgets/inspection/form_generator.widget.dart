import 'package:app/src/models/formControllers.model.dart';
// import 'package:app/src/widgets/inspection/camera_opt.widget.dart';
import 'package:app/src/widgets/inspection/check_box_opt.widget.dart';
import 'package:app/src/widgets/inspection/date_time_picker_opt.widget.dart';
import 'package:app/src/widgets/inspection/drop_down_opt.widget.dart';
import 'package:app/src/widgets/inspection/image_opt.widget.dart';
import 'package:app/src/widgets/inspection/input_text_opt.widget.dart';
import 'package:flutter/material.dart';

class EntryContainer extends StatefulWidget {
  final MapEntry<String, dynamic> entry; // Section Data
  final FormControllers formController;

  const EntryContainer(
      {super.key, required this.entry, required this.formController});

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

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

class _EntryContainerState extends State<EntryContainer> {
  List<Map<String, dynamic>> rows = [];
/* addTableRow Only use for Defualt Table Index Which is "tableIndex": []" 
  Add new row to table view.
  Add new Controller to FormController.
  contraller style is "Section Name-index-fieldKey"
*/
  void addTableRow() {
    setState(() {
      final newRow = Map<String, dynamic>.from(widget.entry.value)
        ..remove('Name');
      final parentKey = widget.entry.key;
      int newIndex = rows.length;
      widget.formController
          .addTableController(newRow, parentKey, newIndex.toString());
      rows.add(newRow);
    });
  }

  @override
  void initState() {
    super.initState();
    final sectionView = widget.entry.value['Name']['SectionView'];
    final tableIndex = widget.entry.value['Name']['tableIndex'];
    if (sectionView == "TableView") {
      // initial table rows, if tableIndex is empty, set index start from 0
      rows = [];
      final parentKey = widget.entry.key;
      if (tableIndex.length > 0) {
        for (int i = 0; i <= tableIndex.length; i++) {
          var index = i.toString();
          if (tableIndex.length >= 1) {
            if (i == tableIndex.length) {
              break;
            }
            index = tableIndex[i];
          }
          rows.add(
              Map<String, dynamic>.from(widget.entry.value)..remove('Name'));
          widget.formController.addTableController(rows[i], parentKey, index);
        }
      } else {
        rows.add(Map<String, dynamic>.from(widget.entry.value)..remove('Name'));
        widget.formController.addTableController(rows[0], parentKey, '0');
      }
    }
  }

  Widget buildFieldText(MapEntry<String, dynamic> field, String parentKey,
      {bool labelDisplay = true}) {
    final fieldData = field.value as Map<String, dynamic>;
    final fieldType = fieldData['Type'];
    final fieldLabel = fieldData['Label'];
    final fieldDbTable = fieldData['DbTableName'];
    final fieldDbColumn = fieldData['DbColumnName'];
    final dbRefKey = fieldData['RefKey'];
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
        widget.formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController(),
            tableName: fieldDbTable,
            columnName: fieldDbColumn,
            refKey: dbRefKey);
        final options = List<String>.from(fieldData['Options'] as List);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...children,
              DropdownBox(
                dropdownOpt: options,
                dbTableName: fieldDbTable,
                dbColumnName: fieldDbColumn,
                refKey: dbRefKey,
                controller: widget.formController
                    .getTextController('$parentKey-$fieldKey'),
                processAutoFill: (refKey, value) {
                  widget.formController.processAutoFill(refKey, value);
                },
              ),
            ],
          ),
        );
      case 'Number':
        widget.formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController(),
            tableName: fieldDbTable,
            columnName: fieldDbColumn,
            refKey: dbRefKey);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              InputBoxOpt(
                label: fieldLabel,
                unit: fieldData['Unit'],
                typeInput: 'number',
                controller: widget.formController
                    .getTextController('$parentKey-$fieldKey'),
              ),
            ],
          ),
        );
      case 'Text':
        widget.formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController(),
            tableName: fieldDbTable,
            columnName: fieldDbColumn,
            refKey: dbRefKey);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              InputBoxOpt(
                label: fieldLabel,
                unit: '',
                typeInput: 'text',
                controller: widget.formController
                    .getTextController('$parentKey-$fieldKey'),
              ),
            ],
          ),
        );
      case 'Comment':
        widget.formController
            .setTextController('$parentKey-$fieldKey', TextEditingController());
        return TextField(
          maxLines: null,
          // expands: true,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.start,
          controller:
              widget.formController.getTextController('$parentKey-$fieldKey'),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            alignLabelWithHint: true,
            labelText: fieldLabel,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      case 'Date':
        widget.formController
            .setDateValue('$parentKey-$fieldKey', DateTime.now());
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              DatePickerExample(
                restorationId: 'main',
                onDateChanged: (newDate) {
                  widget.formController
                      .setDateValue('$parentKey-$fieldKey', newDate!);
                },
              ),
            ],
          ),
        );
      case 'CheckBox':
        widget.formController.setCheckBoxValue('$parentKey-$fieldKey', false);

        return Center(
          child: CheckBoxOpt(
            titleTxt: fieldLabel,
            onChanged: (value) {
              widget.formController
                  .setCheckBoxValue('$parentKey-$fieldKey', value);
            },
          ),
        );
      case 'Images':
      // return const Center(child: cameraOpt());

      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Error'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error: Unknown field type',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Information: \n Code: #101 \n in $parentKey-$fieldKey',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((_) {
            // Ensure we pop back to the main screen if the dialog is closed by any means
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
        });
        return Container();
    }
  }

/* ******************Section Process******************* */
/*
Tabel View
- field: Table Section data.
- parentKey: Section Name(Title).
- tableInfo: Table Information{
              expandable: is this table can add row by user. 
              tableIndex: Defualt table index
              }.
 */
  Widget buildTableView(Map<String, dynamic> field, String parentKey,
      Map<String, dynamic> tableInfo) {
    final headers = <Widget>[
      Container(),
    ];
    final expandable = tableInfo['Expandable'];
    final tableIndex = tableInfo['tableIndex'];

    // Table Column Headers
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

    // Table Rows by index
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
                  addTableRow();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                    ),
                    Text(' Add Row',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ))
            : Container(),
      ],
    ));
  }

/*
Form View: Generate View.
- field: Section data.
- parentKey: Section Name(Title).
- widthSize: app window size, inheritance from build(MediaQuery.of(context).size.width)
 */
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Map<String, dynamic>.from(widget.entry.value);
    /* Collect Section Data, 
    it contain how the section display and 
    send data to different process by sectionView */
    final subTitle = data['Name']['Label'];
    final alert = data['Name']['Alert'];
    final hint = data['Name']['Hint'];
    final sectionView = data['Name']['SectionView'];
    final widgets = <Widget>[];
    final widthSize = MediaQuery.of(context).size.width;
    final parentKey = widget.entry.key;
    if (sectionView == "TableView") {
      final Map<String, dynamic> tableInfo = {
        'Expandable': data['Name']['Expandable'],
        'tableIndex': data['Name']['tableIndex']
      };
      data.remove('Name');
      widgets.add(SizedBox(
          width: widthSize * 0.85,
          child: buildTableView(data, parentKey, tableInfo)));
    } else if (sectionView == "Images") {
      widgets.add(PhotoUploadExample());
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
