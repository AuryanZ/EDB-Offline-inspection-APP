import 'package:flutter/material.dart';

class CheckBoxOpt extends StatefulWidget {
  final String titleTxt;
  final ValueChanged<bool> onChanged;
  const CheckBoxOpt(
      {super.key, required this.titleTxt, required this.onChanged});

  @override
  State<CheckBoxOpt> createState() => _CheckBoxOpt();
}

class _CheckBoxOpt extends State<CheckBoxOpt> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final String titleTxt = widget.titleTxt;
    if (titleTxt == "") {
      return Checkbox(
        value: isChecked,
        activeColor: Colors.green,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            widget.onChanged(isChecked);
          });
        },
      );
    } else {
      return CheckboxListTile(
        title: Text(
          titleTxt,
          style: DefaultTextStyle.of(context)
              .style
              .apply(fontSizeFactor: 1.5, fontWeightDelta: 2),
        ),
        value: isChecked,
        activeColor: Colors.green,
        onChanged: (bool? value) {
          setState(() {
            isChecked = value!;
            widget.onChanged(isChecked);
          });
        },
      );
    }
  }
}
