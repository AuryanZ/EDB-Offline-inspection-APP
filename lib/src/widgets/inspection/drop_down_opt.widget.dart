import 'package:flutter/material.dart';

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width * 0.25,
      // width: 300,
      initialSelection: list.first,
      onSelected: (String? value) {
        setState(() {});
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
