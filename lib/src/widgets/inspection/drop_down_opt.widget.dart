import 'package:app/src/services/autFillDB.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DropdownBox extends StatefulWidget {
  final List<String> dropdownOpt;
  final ValueChanged<String?> onChanged;
  final String? dbTableName;
  final String? dbColumnName;
  final String? refKey;

  const DropdownBox(
      {super.key,
      required this.dropdownOpt,
      required this.onChanged,
      this.dbTableName,
      this.dbColumnName,
      this.refKey});

  @override
  State<DropdownBox> createState() => _DropdownBoxState();
}

class _DropdownBoxState extends State<DropdownBox> {
  String? selectedValue;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    options = widget.dropdownOpt;
    if (options[0] == 'db') {
      final autoFillDB = AutoFillDbServices();
      autoFillDB
          .getColumn(widget.dbTableName!, widget.dbColumnName!)
          .then((value) {
        if (value.isNotEmpty) {
          setState(() {
            options.addAll(value.map((dynamic item) => item.toString()));
            options.removeAt(0);
          });
        }
      });
    }
  }

  Future<List<String>> _getSuggestions(String pattern) async {
    return options
        .where((option) => option.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // List<String> list = widget.dropdownOpt;
    // List<String> list = options;
    return Container(
        decoration: const BoxDecoration(
            // border: Border(
            //   top: BorderSide(),
            //   left: BorderSide(),
            //   right: BorderSide(),
            //   bottom: BorderSide(),
            // ),
            ),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TypeAheadField<String>(
              builder: (context, TextEditingController builderController,
                  focusNode) {
                return TextField(
                    // mouseCursor: MouseCursor.defer,
                    controller: selectedValue == null
                        ? builderController
                        : TextEditingController(text: selectedValue),
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.expand_more,
                      ),
                    ));
              },
              itemBuilder: (context, options) {
                return ListTile(
                  title: Text(options),
                );
              },
              onSelected: (String newValue) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.onChanged(newValue);
              },
              suggestionsCallback: _getSuggestions,
            )));
  }
}
