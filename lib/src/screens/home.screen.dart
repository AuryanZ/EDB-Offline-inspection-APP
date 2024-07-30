import 'package:app/src/widgets/home/inspection_record.widget.dart';
import 'package:app/src/widgets/home/sideManue/select_inspection.widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
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
                minWidth: viewportConstraints.maxWidth,
              ),
              child: const InspectionRecord(),
            ),
          );
        }),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/img/logo.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              child: SizedBox(
                height: screenWidth,
                width: screenWidth,
              ),
            ),
            const Expanded(child: InspectionSelection()),
          ],
        ),
      ),
    );
  }
}
