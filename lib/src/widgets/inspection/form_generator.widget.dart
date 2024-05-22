import 'package:app/src/widgets/inspection/check_box_opt.widget.dart';
import 'package:app/src/widgets/inspection/drop_down_opt.widget.dart';
import 'package:app/src/widgets/inspection/input_text_opt.widget.dart';
import 'package:flutter/material.dart';

class EntryContainer extends StatelessWidget {
  final MapEntry<String, dynamic> entry;

  const EntryContainer({super.key, required this.entry});

  Widget buildFieldText(MapEntry<String, dynamic> field) {
    Map<String, dynamic> fieldData = field.value;
    // return Text(fieldData['Label']);
    if (fieldData['Type'] == 'Dropdown') {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          // const Spacer(),
          // const Expanded(
          // child:
          const DropdownMenuExample(),
          // ),
        ],
      );
      // DropdownMenuExample();
    } else if (fieldData['Type'] == "Number") {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          InputBoxOpt(
            label: fieldData['Label'],
            typeInput: 'number',
          )
        ],
      );
    } else if (fieldData['Type'] == 'Text') {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              fieldData['Label'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          InputBoxOpt(
            label: fieldData['Label'],
            typeInput: 'text',
          )
          // )
        ],
      );
      // return
    } else if (fieldData['Type'] == 'Date') {
      return TextFormField(
        decoration: const InputDecoration(labelText: "todo: Date Picker "),
      );
    } else if (fieldData['Type'] == 'CheckBox') {
      return CheckBoxOpt(titleTxt: fieldData['Label']);
    } else {
      return const Text("Unknown Field Type");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> data = entry.value;
    Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
    final subTitle = data['Name'];
    data.remove('Name');
    if (data.keys.first == "Comments") {
      return Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              const Text(
                "COMMENTS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 200,
                child: const TextField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "COMMENT",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ));
    } else {
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
              Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      // flex: 1,
                      child: buildFieldText(data.entries.elementAt(i)),
                    ),
                  ),
                  if (i + 1 < data.entries.length)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: buildFieldText(data.entries.elementAt(i + 1)),
                      ),
                    ),
                  if (i + 1 == data.entries.length)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.transparent,
                    ),
                ],
              ),
            // Spacer(),
          ],
        ),
      );
    }
  }
}
