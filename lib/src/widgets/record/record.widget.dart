import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:flutter/material.dart';

class RecordTable extends StatefulWidget {
  final bool isSyncedStatus;
  const RecordTable({super.key, required this.isSyncedStatus});

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

  Future<List> _getUnsyncedInspections(bool status) async {
    final recordDb = InspectionRecordDB();
    List<dynamic> inspectionListTemp = [];
    await recordDb.getInspectionList(status).then((value) {
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
    List<dynamic> unsyncedInspections =
        await _getUnsyncedInspections(widget.isSyncedStatus);
    // await Future.delayed(const Duration(seconds: 5));
    setState(() {
      inspectionList = unsyncedInspections;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadUnsyncedInspections();
    return Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                                    DataColumn(
                                        label: Text(
                                      'Auction',
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
                                        DataCell(
                                          inspection['status'] == 'Unsynced'
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.edit),
                                                      onPressed: () {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             InspectionForm(
                                                        //                 inspection: inspection)));
                                                      },
                                                    ),
                                                    const Text("|",
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                        )),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.remove_red_eye,
                                                      ),
                                                      onPressed: () {
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) =>
                                                        //             InspectionForm(
                                                        //                 inspection: inspection)));
                                                      },
                                                    )
                                                  ],
                                                )
                                              : IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_red_eye,
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             InspectionForm(
                                                    //                 inspection: inspection)));
                                                  },
                                                ),
                                        )
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                widget.isSyncedStatus
                    ? const Text("")
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // upload button
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              onPressed: () {
                                // deleteInspections();
                              },
                              icon:
                                  const Icon(Icons.upload, color: Colors.white),
                              label: const Text('Upload',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            // delete button
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              onPressed: () {
                                // deleteInspections();
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
        ));
  }
}
