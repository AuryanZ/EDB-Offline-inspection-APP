import 'dart:convert';

import 'package:app/src/data/templates.data.dart';
import 'package:app/src/utils/progressIndicator.utils.dart';
import 'package:app/src/screens/inspection.screen.dart';
import 'package:flutter/material.dart';

class ZoneSubInspectionTile extends StatefulWidget {
  final Templates template;

  const ZoneSubInspectionTile({super.key, required this.template});

  @override
  State<ZoneSubInspectionTile> createState() => _ZoneSubInspectionTileState();
}

class _ZoneSubInspectionTileState extends State<ZoneSubInspectionTile> {
  bool _isExpanded = false;
  // bool _isSubExpanded = false;
  TextStyle _textStyle = const TextStyle(color: Colors.black);
  final List<TextStyle> _subTextStyle = [
    const TextStyle(color: Colors.black),
    const TextStyle(color: Colors.black)
  ];

  @override
  Widget build(BuildContext context) {
    List<String> subButtonNames = ["Annual", "Bi Monthly"];

    return ExpansionTile(
      title: Text(
        "Zone Sub Inspection",
        style: _textStyle,
      ),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
          _textStyle = expanded
              ? const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)
              : const TextStyle(color: Colors.black);
          if (!expanded) {
            _subTextStyle[0] = const TextStyle(color: Colors.black);
            _subTextStyle[1] = const TextStyle(color: Colors.black);
          }
        });
      },
      // backgroundColor: _isExpanded ? Colors.white : Colors.grey,
      children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.only(left: 20),
          shrinkWrap: true,
          itemCount: subButtonNames.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              title: Text(subButtonNames[index], style: _subTextStyle[index]),
              onExpansionChanged: (value) => setState(() {
                // _isSubExpanded = value;
                _subTextStyle[index] = value
                    ? const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)
                    : const TextStyle(color: Colors.black);
              }),
              children: [
                FutureBuilder(
                  future: widget.template.loadForm("Zone Sub Inspection"),
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
                      Map<String, dynamic> subSubButtonNames =
                          json.decode(snapshot.data);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            subSubButtonNames[subButtonNames[index]].length,
                        itemBuilder: (BuildContext context, int subIndex) {
                          return ListTile(
                            title: Text(subSubButtonNames[subButtonNames[index]]
                                [subIndex]),
                            onTap: () {
                              Navigator.pop(context); // Close the dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InspectionFormScreen(
                                    title:
                                        subSubButtonNames[subButtonNames[index]]
                                            [subIndex],
                                    template: widget.template,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
