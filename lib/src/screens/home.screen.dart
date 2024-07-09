// import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/widgets/home/record_status.widget.dart';
import 'package:app/src/widgets/home/select_inspection.widget.dart';
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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.apps_sharp,
                  size: 35,
                ),
                padding: EdgeInsets.zero,
                tooltip: "New Inspection",
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          )),
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
              child: const InspectionRecordStatus(),
            ),
          );
        }),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/img/logo.jpg'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              child: SizedBox(
                height: 200,
                width: 500,
              ),
            ),
            Expanded(child: InspectionSelection(buttonNames: buttonNames)),
          ],
        ),
      ),
    );
  }
}
