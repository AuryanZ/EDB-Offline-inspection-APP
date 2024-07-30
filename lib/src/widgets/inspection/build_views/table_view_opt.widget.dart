import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/widgets/inspection/components/components_controller.widget.dart';
import 'package:flutter/material.dart';

class BuildTableView extends StatefulWidget {
  final Map<String, dynamic> field;
  final String parentKey;
  // final Map<String, dynamic> tableInfo;
  final FormControllers formController;

  const BuildTableView(
      {super.key,
      required this.field,
      required this.parentKey,
      required this.formController});

  @override
  State<BuildTableView> createState() => _BuildTableViewState();
}

class _BuildTableViewState extends State<BuildTableView> {
  List<Map<String, dynamic>> rows = [];
  dynamic expandable;
  dynamic tableIndex;
  @override
  void initState() {
    super.initState();
    expandable = widget.field['Name']?['Expandable'];
    tableIndex = widget.field['Name']?['tableIndex'];
    rows = [];
    final parentKey = widget.parentKey;
    // final tableIndex = widget.field['Name']?['tableIndex'] ?? "";
    if (tableIndex.length > 0) {
      for (int i = 0; i <= tableIndex.length; i++) {
        var index = i.toString();
        if (tableIndex.length >= 1) {
          if (i == tableIndex.length) {
            break;
          }
          index = tableIndex[i];
        }
        rows.add(Map<String, dynamic>.from(widget.field)..remove('Name'));
        widget.formController.addTableController(rows[i], parentKey, index);
      }
    } else {
      rows.add(Map<String, dynamic>.from(widget.field)..remove('Name'));
      widget.formController.addTableController(rows[0], parentKey, '0');
    }
  }

  /* addTableRow Only use for Defualt Table Index Which is "tableIndex": []" 
  Add new row to table view.
  Add new Controller to FormController.
  contraller style is "Section Name-index-fieldKey"
*/
  void addTableRow() {
    setState(() {
      // print(widget.field);
      final newRow = Map<String, dynamic>.from(widget.field)..remove('Name');
      final parentKey = widget.parentKey;
      int newIndex = rows.length;
      widget.formController
          .addTableController(newRow, parentKey, newIndex.toString());
      rows.add(newRow);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> headers = <Widget>[
      // index column
      Container(),
    ];
    final field = widget.field;
    // final Map<String, dynamic> tableInfo = {
    //   'Expandable': field['Name']?['Expandable'],
    //   'tableIndex': field['Name']?['tableIndex']
    // };
    String parentKey = widget.parentKey;
    field.remove('Name');

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
            fontSize: 15,
          ),
          // softWrap: false,
        ),
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
            child:
                // buildFieldText(
                //     MapEntry(entry.key, entry.value), '$parentKey-$keyIndex',
                //     labelDisplay: false),
                BuildFields(
              field: MapEntry(entry.key, entry.value),
              parentKey: '$parentKey-$keyIndex',
              formController: widget.formController,
              labelDisplay: false,
            ),
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
}
