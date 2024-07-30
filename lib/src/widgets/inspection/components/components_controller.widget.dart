import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/widgets/inspection/components/check_box_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/date_time_picker_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/drop_down_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/input_text_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/photo_upload_opt.widget.dart';
import 'package:flutter/material.dart';

class BuildFields extends StatelessWidget {
  final MapEntry<String, dynamic> field;
  final String parentKey;
  final bool labelDisplay;
  final FormControllers formController;

  const BuildFields(
      {super.key,
      required this.field,
      required this.parentKey,
      required this.formController,
      this.labelDisplay = true});

  @override
  Widget build(BuildContext context) {
    final fieldData = field.value as Map<String, dynamic>;
    final String fieldType = fieldData['Type'];
    final fieldLabel = fieldData['Label'];
    final fieldDbTable = fieldData['DbTableName'];
    final fieldDbColumn = fieldData['DbColumnName'];
    final dbRefKey = fieldData['RefKey'];
    final isRequired = fieldData['Required'];
    final fieldKey = field.key;
    final children = labelDisplay
        ? <Widget>[
            SizedBox(
              child: Text(
                isRequired ? "$fieldLabel*" : "$fieldLabel",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ]
        : <Widget>[];
    switch (fieldType.toLowerCase()) {
      case 'dropdown':
        // case 'dialogview':
        formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController(),
            tableName: fieldDbTable,
            columnName: fieldDbColumn,
            refKey: dbRefKey);
        final options = List<String>.from(fieldData['Options'] as List);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...children,
              DropdownBox(
                dropdownOpt: options,
                dbTableName: fieldDbTable,
                dbColumnName: fieldDbColumn,
                refKey: dbRefKey,
                controller:
                    formController.getTextController('$parentKey-$fieldKey'),
                processAutoFill: (refKey, value) {
                  formController.processAutoFill(refKey, value);
                },
              ),
            ],
          ),
        );
      case 'number':
      case 'text':
        formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController(),
            tableName: fieldDbTable,
            columnName: fieldDbColumn,
            refKey: dbRefKey);
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              InputBoxOpt(
                label: fieldLabel,
                unit: fieldData['Unit'],
                typeInput: fieldType.toLowerCase(),
                controller:
                    formController.getTextController('$parentKey-$fieldKey'),
              ),
            ],
          ),
        );
      case 'comment':
        formController.setTextController(
            '$parentKey-$fieldKey', TextEditingController());
        return TextField(
          maxLines: null,
          // expands: true,
          keyboardType: TextInputType.multiline,
          textAlign: TextAlign.start,
          controller: formController.getTextController('$parentKey-$fieldKey'),
          decoration: InputDecoration(
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            alignLabelWithHint: true,
            labelText: labelDisplay ? fieldLabel : "",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      case 'date':
        formController.setDateValue('$parentKey-$fieldKey', DateTime.now());
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              DatePickerDialogOverride(
                restorationId: 'main',
                onDateChanged: (newDate) {
                  formController.setDateValue('$parentKey-$fieldKey', newDate!);
                },
              ),
            ],
          ),
        );
      case 'checkbox':
        formController.setCheckBoxValue('$parentKey-$fieldKey', false);

        return Center(
          child: CheckBoxOpt(
            titleTxt: labelDisplay ? fieldLabel : "",
            onChanged: (value) {
              formController.setCheckBoxValue('$parentKey-$fieldKey', value);
            },
          ),
        );
      case 'images':
        bool isMultiImg = false;
        formController.setImageListController('$parentKey-$fieldKey', []);
        if (fieldData['Unit'] != null && fieldData['Unit'] == "Multi") {
          isMultiImg = true;
        }
        return Center(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...children,
              PhotoUploadOpt(
                images: formController
                    .imageListControllers['$parentKey-$fieldKey']!,
                multiImg: isMultiImg,
              )
            ],
          ),
        );

      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Error'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error: Unknown field type',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Information: \n Code: #101 \n in $parentKey-$fieldKey Type: $fieldType',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((_) {
            // Ensure we pop back to the main screen if the dialog is closed by any means
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
        });
        return Container();
    }
  }
}
