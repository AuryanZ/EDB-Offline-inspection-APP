import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:flutter/material.dart';

class InspectionRecordStatus extends StatefulWidget {
  const InspectionRecordStatus({super.key});

  @override
  State<InspectionRecordStatus> createState() => _InspectionRecordStatusState();
}

class _InspectionRecordStatusState extends State<InspectionRecordStatus> {
  final recordDb = InspectionRecordDB();
  List<dynamic> inspectionList = [];
  bool isLoading = true;
  bool selecteAll = false;
  Map<int, bool> checkedStatus = {};

  @override
  void initState() {
    super.initState();
    _loadUnsyncedInspections();
  }

  Future<List> _getUnsyncedInspections() async {
    final recordDb = InspectionRecordDB();
    List<dynamic> inspectionListTemp = [];
    await recordDb.getInspectionList(false).then((value) {
      if (value != null) {
        for (var element in value) {
          inspectionListTemp.add(element.toListMap());
        }
      }
    });

    recordDb.dispose();
    return inspectionListTemp;
  }

  Future<void> _loadUnsyncedInspections() async {
    List<dynamic> unsyncedInspections = await _getUnsyncedInspections();
    setState(() {
      inspectionList = unsyncedInspections;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    recordDb.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("Inspection Record Status");
    return Center(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You have ${inspectionList.length} unsynced inspections.",
                style: const TextStyle(fontSize: 20)),
            isLoading
                ? const CircularProgressIndicator()
                : inspectionList.isEmpty
                    ? const Text("No unsynced inspections found.")
                    : Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FixedColumnWidth(200), // Name
                              2: FixedColumnWidth(200), // Job
                              3: IntrinsicColumnWidth(), // Status
                              4: FixedColumnWidth(200), // Inspection Date
                              5: FixedColumnWidth(200), // Last Modified Date
                              6: IntrinsicColumnWidth(),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    // child: Center(
                                    child: Checkbox(
                                      value: selecteAll,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selecteAll = value!;
                                          for (var inspection
                                              in inspectionList) {
                                            checkedStatus[inspection["id"]] =
                                                value;
                                          }
                                        });
                                      },
                                    )),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                      child: Text(
                                        "Job",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                        child: Text(
                                      "Status",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ))),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                        child: Text(
                                      "Inspection Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ))),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                        child: Text(
                                      "Last Modified Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ))),
                                const TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Center(
                                        child: Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ))),
                              ]),
                              for (var inspection in inspectionList)
                                TableRow(children: [
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Checkbox(
                                        value:
                                            checkedStatus[inspection["id"]] ??
                                                false,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkedStatus[inspection["id"]] =
                                                value!;
                                          });
                                        },
                                      )),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(inspection["name"]))),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(inspection["Job"]))),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(inspection["status"]))),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              inspection["inspectionDate"]))),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              inspection["lastModifedDate"]))),
                                  TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit_sharp,
                                            ),
                                          ))),
                                ])
                            ],
                          ),
                        )),
                      ),
          ],
        ),
      ),
    );
  }
}
