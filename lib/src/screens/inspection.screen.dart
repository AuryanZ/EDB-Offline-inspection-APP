import 'dart:convert';
import 'package:app/src/widgets/inspection/form_generator.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key, required this.title});

  final String title;

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreen();
}

class _InspectionFormScreen extends State<InspectionFormScreen> {
  final Map<String, TextEditingController> textControllers = {};
  final Map<String, String> dropdownValues = {};
  final Map<String, DateTime> dateValues = {};
  final Map<String, bool> checkBoxValues = {};

  Future<String> loadForm() async {
    final formName = "${widget.title.replaceAll(" ", "_").toLowerCase()}.json";
    // print(formName);
    try {
      return await rootBundle.loadString('assets/form_temp/$formName');
    } catch (e) {
      return '{"Title": "Template Not Found"}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadForm(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> data = json.decode(snapshot.data!);

          final formTitle = data['Title'];
          data.remove('Title');
          // Initialize controllers
          data.forEach((key, value) {
            value.forEach((subKey, subValue) {
              //check if subValue have type
              if (subKey != 'Name') {
                if (subValue['Type'] == 'Text' ||
                    subValue['Type'] == 'Number' ||
                    subValue['Type'] == 'Comment') {
                  textControllers['$key-$subKey'] = TextEditingController();
                } else if (subValue['Type'] == 'Dropdown') {
                  dropdownValues['$key-$subKey'] = '';
                } else if (subValue['Type'] == 'Date') {
                  dateValues['$key-$subKey'] = DateTime.now();
                } else if (subValue['Type'] == 'Checkbox') {
                  checkBoxValues['$key-$subKey'] = false;
                }
              }
            });
          });
          // print(textControllers.keys.toList());
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                // padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            formTitle,
                            // style: const TextStyle(
                            //     fontWeight: FontWeight.bold, fontSize: 40),

                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 3.0, fontWeightDelta: 2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: [
                            for (var entry in data.entries)
                              EntryContainer(
                                entry: entry,
                                textControllers: textControllers,
                                dropdownValues: dropdownValues,
                                dateValues: dateValues,
                                checkBoxValues: checkBoxValues,
                              ),
                          ]),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onPrimary,
                          thickness: 2,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.25, 50),
                              elevation: 5,
                              shadowColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                            ),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              final collectedData = {
                                'textFields': textControllers.map(
                                    (key, controller) =>
                                        MapEntry(key, controller.text)),
                                'dropdowns': dropdownValues,
                                'dates': dateValues,
                                'checkboxes': checkBoxValues,
                              };
                              print(collectedData);
                              if (true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')));
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onPrimary,
                          thickness: 2,
                        ),
                      ],
                    )),
              );
            }),
          );
        }
      },
    );
  }
}
