import 'package:app/src/data/templates.data.dart';
import 'package:app/src/utils/progressIndicator.utils.dart';
import 'package:app/src/widgets/inspection/save_inspection.widget.dart';
import 'package:flutter/material.dart';

class InspectionFormScreen extends StatelessWidget {
  const InspectionFormScreen(
      {super.key, required this.title, required this.template});

  final String title;
  final Templates template;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: template.loadForm(title),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(title),
              ),
              body: const CustomProgressIndicator(
                // size: 200,
                color: Colors.grey,
                duration: Duration(seconds: 5),
                strokeWidth: 3.0,
                type: ProgressIndicatorType.circular,
              ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(title),
            ),
            body: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
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
              );
            }),
          );
        }
      },
    );
  }
}
