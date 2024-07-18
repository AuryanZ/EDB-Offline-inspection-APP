import 'dart:convert';
import 'package:app/src/data/templates.data.dart';
import 'package:app/src/models/progressIndicator.model.dart';
import 'package:app/src/screens/inspection.screen.dart';
import 'package:flutter/material.dart';

class InspectionSelection extends StatelessWidget {
  const InspectionSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final Templates template = Templates();

    return FutureBuilder(
      future: template.setInspectionNames(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingList(scrollController);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final buttonNames = template.getInspectionNames();
          return _buildInspectionList(
              context, scrollController, buttonNames, template);
        }
      },
    );
  }

  Widget _buildLoadingList(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: 8,
      itemBuilder: (context, index) {
        return const ListTile(
          title: CustomProgressIndicator(
            color: Colors.grey,
            duration: Duration(seconds: 5),
            strokeWidth: 3.0,
            type: ProgressIndicatorType.circular,
          ),
        );
      },
    );
  }

  Widget _buildInspectionList(
      BuildContext context,
      ScrollController scrollController,
      List<String> buttonNames,
      Templates template) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: buttonNames.length,
        itemBuilder: (context, index) {
          if (buttonNames[index] == "Zone Sub Inspection") {
            return _buildZoneSubInspectionTile(context, template);
          } else {
            return ListTile(
              title: Text(buttonNames[index]),
              onTap: () => _navigateToInspectionFormScreen(
                  context, buttonNames[index], template),
            );
          }
        },
      ),
    );
  }

  Widget _buildZoneSubInspectionTile(BuildContext context, Templates template) {
    final List<String> subButtonNames = ["Annual", "Bi Monthly"];
    return ExpansionTile(
      title: const Text("Zone Sub Inspection"),
      children: subButtonNames.map((subButtonName) {
        return ExpansionTile(
          tilePadding: const EdgeInsets.only(left: 40, right: 20),
          title: Text(subButtonName),
          children: [
            FutureBuilder(
              future: template.loadForm("Zone Sub Inspection"),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    title: CustomProgressIndicator(
                      color: Colors.grey,
                      duration: Duration(seconds: 5),
                      strokeWidth: 3.0,
                      type: ProgressIndicatorType.circular,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final Map<String, dynamic> subSubButtonNames =
                      json.decode(snapshot.data);
                  return _buildSubSubButtonList(context, subButtonName,
                      subSubButtonNames[subButtonName], template);
                }
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSubSubButtonList(BuildContext context, String subButtonName,
      List<dynamic> subSubButtonNames, Templates template) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 40),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subSubButtonNames.length,
      itemBuilder: (context, subIndex) {
        return ListTile(
          title: Text(subSubButtonNames[subIndex]),
          onTap: () => _navigateToInspectionFormScreen(
              context, subSubButtonNames[subIndex], template),
        );
      },
    );
  }

  void _navigateToInspectionFormScreen(
      BuildContext context, String title, Templates template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspectionFormScreen(
          title: title,
          template: template,
        ),
      ),
    );
  }
}
