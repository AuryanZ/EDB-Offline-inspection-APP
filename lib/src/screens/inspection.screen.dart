import 'package:app/src/data/templates.data.dart';
// import 'package:app/src/services/inspectionRecordDB.services.dart';
import 'package:app/src/widgets/inspection/save_inspection_opt.widget.dart';
import 'package:flutter/material.dart';

class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key, required this.title});

  final String title;

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreen();
}

class _InspectionFormScreen extends State<InspectionFormScreen> {
  // final appDB = InspectionRecordDB();
  Templates template = Templates();
  bool isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: template.loadForm(widget.title),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          template.setData(snapshot.data!);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                // child: ConstrainedBox(
                //   constraints: BoxConstraints(
                //     minHeight: viewportConstraints.maxHeight,
                //   ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        template.title,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 3.0, fontWeightDelta: 2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: template.getInpectSections()),
                      // children: getInpectSections(template.data)),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.onPrimary,
                      thickness: 2,
                    ),
                    template.isLoaded
                        ? SaveButtonWidget(template: template)
                        : const Text(''),
                    Divider(
                      color: Theme.of(context).colorScheme.onPrimary,
                      thickness: 2,
                    ),
                  ],
                ),
                // ),
              );
            }),
          );
        }
      },
    );
  }
}
