import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBoxOpt extends StatelessWidget {
  final String label;
  final String typeInput;
  final String? unit;
  final TextEditingController controller;
  const InputBoxOpt(
      {super.key,
      required this.label,
      required this.typeInput,
      required this.unit,
      required this.controller});

  // @override
  // State<InputBoxOpt> createState() => _InputBoxOptState();

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    dynamic unit = this.unit;
    final typeInput = this.typeInput;
    final controller = this.controller;
    if (typeInput == 'number') {
      if (unit != null && unit.startsWith("sp-")) {
        // process for special constant
        var hexNumber = int.parse(unit.replaceAll("sp-0x", ""), radix: 16);
        unit = String.fromCharCode(hexNumber);
        // unit = "$unit";
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        child: TextField(
          style: const TextStyle(fontSize: 20),
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'[^\d+\-\.i]')),
          ],
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            suffixIcon: Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, right: 15.0, bottom: 15.0),
              child: Text(unit == null || unit.isEmpty ? '' : unit),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 20),
          controller: controller,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }
  }
}

// class _InputBoxOptState extends State<InputBoxOpt> {
//   @override
//   Widget build(BuildContext context) {
//     final label = widget.label;
//     final unit = widget.unit;
//     final typeInput = widget.typeInput;
//     final controller = widget.controller;
//     if (typeInput == 'number') {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width * 0.50,
//         child: TextFormField(
//           style: const TextStyle(fontSize: 20),
//           controller: controller,
//           keyboardType: TextInputType.number,
//           inputFormatters: <TextInputFormatter>[
//             FilteringTextInputFormatter.deny(RegExp(r'[^\d+\-\.i]')),
//           ],
//           decoration: InputDecoration(
//             labelText: label,
//             labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//             suffixIcon: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Text(unit == null || unit.isEmpty ? '' : unit),
//             ),
//             border: const OutlineInputBorder(),
//           ),
//         ),
//       );
//     } else {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width * 0.50,
//         child: TextFormField(
//           style: const TextStyle(fontSize: 20),
//           controller: controller,
//           decoration: InputDecoration(
//             labelStyle: const TextStyle(color: Colors.grey, fontSize: 15),
//             labelText: label,
//             border: const OutlineInputBorder(),
//           ),
//         ),
//       );
//     }
//   }
// }
