import 'dart:convert';
import 'package:app/src/data/formControllers.model.dart';
import 'package:app/src/services/database.services.dart';
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
  final appDB = DatabaseService();
  FormControllers formController = FormControllers();
  bool isLoaded = false;

  Future<String> loadForm() async {
    // final allInspections = appDB.getInspections();
    // print(allInspections);
    final formName =
        "${widget.title.replaceAll(" ", "_").toLowerCase()}.dataFormTemp";
    try {
      isLoaded = true;
      return await rootBundle.loadString('assets/form_temp/$formName');
    } catch (e) {
      isLoaded = false;
      return '{"Title": "Template Not Found"}';
    }
  }

  List<Widget> getInpectSections(Map<String, dynamic> data) {
    final children = <Widget>[];
    for (var entry in data.entries) {
      children.add(EntryContainer(
        entry: entry,
        formController: formController,
      ));
    }
    return children;
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
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            formTitle,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 3.0, fontWeightDelta: 2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: getInpectSections(data)),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.onPrimary,
                          thickness: 2,
                        ),
                        isLoaded
                            ? Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        50),
                                    elevation: 5,
                                    shadowColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                  ),
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    print(formController.getControllersValue());
                                    if (true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Processing Data')));
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              )
                            : const Text(''),
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
