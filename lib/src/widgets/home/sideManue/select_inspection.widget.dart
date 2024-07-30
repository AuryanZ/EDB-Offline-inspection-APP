import 'package:app/src/data/templates.data.dart';
import 'package:app/src/utils/progressIndicator.utils.dart';
import 'package:app/src/screens/inspection.screen.dart';
import 'package:app/src/widgets/home/sideManue/zoneSub_title.widget.dart';
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
          return Text('Error: ${snapshot.error}');
        } else {
          final buttonNames = template.getInspectionNames();
          return Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: buttonNames.length,
              itemBuilder: (context, index) {
                if (buttonNames[index] == "Zone Sub Inspection") {
                  return ZoneSubInspectionTile(template: template);
                } else {
                  return ListTile(
                    title: Text(buttonNames[index]),
                    onTap: () async {
                      Navigator.pop(context); // Close the dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InspectionFormScreen(
                              title: buttonNames[index], template: template),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
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
}
