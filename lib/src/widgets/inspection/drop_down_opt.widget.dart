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

    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width * 0.25,
      initialSelection: selectedValue,
      onSelected: (String? value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value);
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
