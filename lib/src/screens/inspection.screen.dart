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
  Future<String> loadForm() async {
    final formName = "${widget.title.replaceAll(" ", "_").toLowerCase()}.json";
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
                        Column(children: [
                          for (var entry in data.entries)
                            EntryContainer(entry: entry),
                        ]),
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
