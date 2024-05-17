import 'package:flutter/material.dart';

class EntryContainer extends StatelessWidget {
  final MapEntry<String, dynamic> entry;

  const EntryContainer({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = entry.value;
    String subTitle = entry.value['Name'];
    data.remove('Name');
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            subTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          for (int i = 0; i < data.entries.length; i += 2)
            Row(
              children: [
                Expanded(
                  flex: 1,
                  // child: Align(
                  // alignment: Alignment.centerLeft,
                  child: buildFieldText(data.entries.elementAt(i)),
                  // ),
                ),
                if (i + 1 < data.entries.length)
                  Expanded(
                    flex: 1,
                    // child: Align(
                    // alignment: Alignment.centerLeft,
                    child: buildFieldText(data.entries.elementAt(i + 1)),
                    // ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildFieldText(MapEntry<String, dynamic> field) {
    //   FieldData fieldData = FieldData.fromJson(jsonDecode(field.value.to));
    //   return Text("key: " + fieldData.label);
    // }
    Map<String, dynamic> fieldData = field.value;
    // return Text(fieldData['Label']);
    return Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        child: Row(children: [
          Text(
            fieldData['Label'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 20),
          const DropdownMenuExample(),
          // Text(
          //   fieldData['Unit'] ?? "No Unit",
          //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          // ),
          // Text(
          //   fieldData['Required'] ? "Required" : "Not Required",
          //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          // ),
        ]));
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;

    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
