import 'package:flutter/material.dart';

class CheckBoxOpt extends StatefulWidget {
  final String titleTxt;
  const CheckBoxOpt({super.key, required this.titleTxt});

  @override
  State<CheckBoxOpt> createState() => _CheckBoxOpt();
}

class _CheckBoxOpt extends State<CheckBoxOpt> {
  @override
  Widget build(BuildContext context) {
    final String titleTxt = widget.titleTxt;
    return CheckboxListTile(
      title: Text(
        titleTxt,
        style: DefaultTextStyle.of(context)
            .style
            .apply(fontSizeFactor: 1.5, fontWeightDelta: 2),
      ),
      value: false,
      onChanged: (bool? value) {},
    );
  }
}
