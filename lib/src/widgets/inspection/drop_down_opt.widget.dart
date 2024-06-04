import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  final List<String> dropdownOpt;
  final ValueChanged<String?> onChanged;

  const DropdownMenuExample({
    super.key,
    required this.dropdownOpt,
    required this.onChanged,
  });

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    List<String> list = widget.dropdownOpt;
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(),
            left: BorderSide(),
            right: BorderSide(),
            bottom: BorderSide(),
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            alignment: Alignment.centerRight,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onChanged(newValue);
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }
}
