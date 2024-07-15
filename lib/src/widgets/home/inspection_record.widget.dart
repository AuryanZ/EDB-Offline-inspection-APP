import 'package:app/src/widgets/record/record.widget.dart';
import 'package:flutter/material.dart';

class InspectionRecord extends StatefulWidget {
  const InspectionRecord({super.key});

  @override
  State<InspectionRecord> createState() => _InspectionRecordState();
}

class _InspectionRecordState extends State<InspectionRecord> {
  bool unsyncedCardClicked = false;
  bool syncedCardClicked = false;
  bool searchStatus = false;

  BoxDecoration _getCardDecoration(bool clicked) {
    return BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
          bottom: Radius.circular(0),
        ),
        color: clicked ? Colors.white : Colors.blueGrey,
        border: clicked
            ? const Border(
                top: BorderSide(color: Colors.grey, width: 3),
                left: BorderSide(color: Colors.grey, width: 3),
                right: BorderSide(color: Colors.grey, width: 3),
              )
            : const Border(
                bottom: BorderSide(color: Colors.grey, width: 3),
              ));
  }

  TextStyle _getCardTextStyle(bool clicked) {
    return TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        //if clicked is true then color is defult else white
        color: clicked ? Colors.blueGrey : Colors.white);
  }

  @override
  void initState() {
    super.initState();
    unsyncedCardClicked = true;
    syncedCardClicked = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text("Inspection Record",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 20,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 3),
                        ),
                      ),
                      child: const TextButton(
                        onPressed: null,
                        child: Text(''),
                      ),
                    ),
                  ),
                  Container(
                    decoration: _getCardDecoration(unsyncedCardClicked),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 0),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                                // bottom: Radius.circular(-10),
                              )),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!unsyncedCardClicked) {
                            unsyncedCardClicked = !unsyncedCardClicked;
                            syncedCardClicked = !unsyncedCardClicked;
                          }
                        });
                      },
                      child: Text('Unsynced Inspection',
                          style: _getCardTextStyle(unsyncedCardClicked)),
                    ),
                  ),
                  Container(
                    decoration: _getCardDecoration(syncedCardClicked),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 0),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(1),
                              )),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!syncedCardClicked) {
                            syncedCardClicked = !syncedCardClicked;
                            unsyncedCardClicked = !syncedCardClicked;
                          }
                        });
                      },
                      child: Text('Synced Inspection',
                          style: _getCardTextStyle(syncedCardClicked)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 3),
                        ),
                      ),
                      child: const TextButton(
                        onPressed: null,
                        child: Text(''),
                      ),
                    ),
                  ),
                ],
              ),
              RecordTable(
                isSyncedStatus: syncedCardClicked,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
