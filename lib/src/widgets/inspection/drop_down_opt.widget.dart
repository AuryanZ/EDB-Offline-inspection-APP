import 'package:app/src/services/autFillDB.services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DropdownBox extends StatefulWidget {
  final List<String> dropdownOpt;
  final TextEditingController controller;
  final String? dbTableName;
  final String? dbColumnName;
  final String? refKey;
  final Function? processAutoFill;
  const DropdownBox(
      {super.key,
      required this.dropdownOpt,
      required this.controller,
      this.dbTableName,
      this.dbColumnName,
      this.refKey,
      this.processAutoFill});

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

  void _autoFillUpdate(String value) {
    widget.dbTableName != null &&
            widget.dbColumnName != null &&
            widget.refKey != null
        ? widget.processAutoFill!(widget.refKey!, value)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Container(
        decoration: const BoxDecoration(),
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TypeAheadField<String>(
              builder: (context, TextEditingController builderController,
                  focusNode) {
                return TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 20),
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Select',
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
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
                  controller.text = selectedValue!;
                  _autoFillUpdate(selectedValue!);
                });
              },
              suggestionsCallback: _getSuggestions,
            )));
  }
}
