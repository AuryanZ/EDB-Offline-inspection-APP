import 'package:flutter/material.dart';

class InputBoxOpt extends StatefulWidget {
  final String label;
  final String typeInput;
  const InputBoxOpt({super.key, required this.label, required this.typeInput});

  @override
  State<InputBoxOpt> createState() => _InputBoxOptState();
}

class _InputBoxOptState extends State<InputBoxOpt> {
  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final typeInput = widget.typeInput;
    if (typeInput == 'Number') {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }
  }
}
