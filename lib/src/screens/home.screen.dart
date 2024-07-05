// import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/widgets/home/inspect_selection.widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final buttonNames = [
    "Function Display",
    "Asset Amendment Form",
    "Defect Report (Emergent Sheet)",
    "Job Sheet (UAT)",
    "Battery Inspection",
    "Cable Inspection",
    "Ground Mount TX Inspection",
    "IED Inspection",
    "Pole Inspection",
    "Pillar Box Inspection",
    "SWER Sub Inspection",
    "Voltage Reg Inspection",
    "Zone Sub Inspection",
    "Ground Mount Switchgear Annual Inspection",
  ];

  // final appDB = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        top: true,
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            // padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: InspectionSelection(
                buttonNames: buttonNames,
              ),
            ),
          );
        }),
      ),
    );
  }
}
