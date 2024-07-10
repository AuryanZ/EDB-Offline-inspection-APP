import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:flutter/material.dart';

class RecordTable extends StatefulWidget {
  const RecordTable({super.key});
  @override
  State<RecordTable> createState() => _RecordTableState();
}

class _RecordTableState extends State<RecordTable> {
  List<dynamic> inspectionList = [];
  bool isLoading = true;
  Map<int, bool> checkedStatus = {};

  @override
  void initState() {
    super.initState();
    _loadUnsyncedInspections();
  }

  @override
  void dispose() {
    super.dispose();
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
    // await Future.delayed(const Duration(seconds: 5));
    setState(() {
      inspectionList = unsyncedInspections;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // print(constraints.maxWidth);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : inspectionList.isEmpty
                        ? const Text("No unsynced inspections found.")
                        : Expanded(
                            child: SingleChildScrollView(
                              // scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: DataTable(
                                  columnSpacing: 5,
                                  border: TableBorder.all(),
                                  showBottomBorder: true,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                        label: Text(
                                      'Name',
                                      softWrap: true,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Job',
                                      softWrap: true,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Status',
                                      softWrap: true,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Inspection Date',
                                      softWrap: true,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Last Modified Date',
                                      softWrap: true,
                                    )),
                                  ],
                                  rows: inspectionList.map((inspection) {
                                    return DataRow(
                                      selected:
                                          checkedStatus[inspection["id"]] ??
                                              false,
                                      onSelectChanged: (value) {
                                        setState(() {
                                          checkedStatus[inspection["id"]] =
                                              value!;
                                        });
                                      },
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            inspection['name'],
                                            softWrap: true,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inspection['Job'],
                                            softWrap: true,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inspection['status'],
                                            softWrap: true,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inspection['inspectionDate'],
                                            softWrap: true,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            inspection['lastModifedDate'],
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
              ],
            );
          },
        ));
  }
}
