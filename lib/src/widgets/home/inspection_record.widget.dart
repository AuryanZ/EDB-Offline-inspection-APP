import 'package:app/src/widgets/record/unsynced_record.widget.dart';
import 'package:flutter/material.dart';

class InspectionRecord extends StatefulWidget {
  const InspectionRecord({super.key});

  @override
  State<InspectionRecord> createState() => _InspectionRecordState();
}

class _InspectionRecordState extends State<InspectionRecord> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("Inspection Record Status");
    return const Center(child: RecordTable());
  }
}
