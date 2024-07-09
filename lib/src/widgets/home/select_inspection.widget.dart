import 'package:app/src/screens/inspection.screen.dart';
import 'package:flutter/material.dart';

class InspectionSelection extends StatelessWidget {
  const InspectionSelection({super.key, required this.buttonNames});

  final List<String> buttonNames;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: buttonNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(buttonNames[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InspectionFormScreen(title: buttonNames[index]),
                  ),
                );
              },
            );
          },
        ));
  }
}
