import 'package:app/src/screens/inspection.screen.dart';
import 'package:flutter/material.dart';

class InspectionSelection extends StatelessWidget {
  const InspectionSelection({super.key, required this.buttonNames});

  final List<String> buttonNames;

  Widget buildButtonRow(int index, BuildContext context) {
    final ButtonStyle homePageButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      minimumSize: const Size(100, 80),
      // maximumSize: const Size(300, 90)
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(
              color: Theme.of(context).colorScheme.primary,
            );
          }
          return null; // Defer to the widget's default.
        },
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: ElevatedButton(
              style: homePageButtonStyle,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InspectionFormScreen(title: buttonNames[index * 2]),
                    ));
              },
              child: Text(
                buttonNames[index * 2],
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 50),
          if (index * 2 + 1 < buttonNames.length)
            Expanded(
              child: ElevatedButton(
                style: homePageButtonStyle,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InspectionFormScreen(
                            title: buttonNames[index * 2 + 1]),
                      ));
                  // print(buttonNames[index * 2 + 1]);
                },
                child: Text(
                  buttonNames[index * 2 + 1],
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Expanded(child: Container()),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate((buttonNames.length / 2).ceil(),
              (index) => buildButtonRow(index, context)),
        ),
      ),
    );
  }
}
