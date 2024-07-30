import 'package:app/src/data/formControllers.data.dart';
import 'package:app/src/widgets/inspection/build_views/dialog_view_opt.widget.dart';
import 'package:app/src/widgets/inspection/build_views/form_view_opt.widget.dart';
import 'package:app/src/widgets/inspection/build_views/table_view_opt.widget.dart';
import 'package:app/src/widgets/inspection/components/photo_upload_opt.widget.dart';
import 'package:flutter/material.dart';

class EntryContainer extends StatefulWidget {
  final MapEntry<String, dynamic> entry; // Section Data
  final FormControllers formController;

  const EntryContainer(
      {super.key, required this.entry, required this.formController});

  @override
  State<EntryContainer> createState() => _EntryContainerState();
}

class _EntryContainerState extends State<EntryContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.formController.dispose();
  }

/* ******************Section Field******************* */
  // Widget buildFieldText(MapEntry<String, dynamic> field, String parentKey,
  //     {bool labelDisplay = true}) {
  //   // print("$parentKey-${field.key} \n");
  //   final fieldData = field.value as Map<String, dynamic>;
  //   // if (fieldData.containsKey("OptionViewName")) {
  //   //   // print(fieldData);
  //   //   String refKey = "$parentKey-${fieldData['OptionViewName']['RefKey']}";
  //   //   // fieldData.remove("Name");
  //   //   fieldData.remove("OptionViewName");
  //   //   widget.formController.dialogViewController
  //   //       .setDialogForm(fieldData, refKey);
  //   //   // widget.formController.setTextController(
  //   //   //     '$parentKey-${field.key}', TextEditingController());
  //   //   return Container();
  //   // }

  List<Widget> viewControl(dynamic sectionView, Map<String, dynamic> data,
      double widthSize, String parentKey) {
    final view = <Widget>[];
    if (sectionView == null) {
      throw "SectionView is empty";
    }

    if (sectionView == "TableView") {
      view.add(BuildTableView(
        field: data,
        parentKey: parentKey,
        formController: widget.formController,
      ));
    } else if (sectionView == "FormView") {
      // General View
      data.remove('Name');
      view.add(BuildFormView(
          field: data,
          parentKey: parentKey,
          formController: widget.formController,
          widthSize: widthSize));
    } else if (sectionView == "Images") {
      // General View
      widget.formController.setImageListController(parentKey, []);
      view.add(PhotoUploadOpt(
        images: widget.formController.imageListControllers[parentKey]!,
      ));
    } else if (sectionView == "SubFormView") {
      // special View
      data.remove('Name');
      // view.add(Text(data.toString()));
      for (var entry in data.entries) {
        view.add(EntryContainer(
          entry: MapEntry(entry.key, entry.value),
          formController: widget.formController,
        ));
      }
    } else if (sectionView == "OptionView") {
      try {
        view.add(DialogViewWidget(
          data: data,
          widthSize: widthSize,
          formController: widget.formController,
        ));
      } catch (e) {
        view.add(Text("Error: $e"));
      }
    } else {}
    return view;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Map<String, dynamic>.from(widget.entry.value);
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
    /* Collect Section Data, 
    it contain how the section display and 
    send data to different process by sectionView */
    final subTitle = data['Name']?['Label'] ?? "";
    final alert = data['Name']?['Alert'] ?? "";
    final hint = data['Name']?['Hint'] ?? "";
    final sectionView = data['Name']['SectionView'];
    final widgets = <Widget>[];

    try {
      final widthSize = MediaQuery.of(context).size.width;
      final parentKey = widget.entry.key;
      widgets.addAll(viewControl(sectionView, data, widthSize, parentKey));
    } catch (e) {
      widgets.add(Text("Error: $e"));
      return widgets[0];
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                subTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              if (hint != '')
                Tooltip(
                  key: tooltipkey,
                  message: hint,
                  child: InkWell(
                    onTap: () {
                      tooltipkey.currentState?.ensureTooltipVisible();
                    },
                    child: const Icon(
                      Icons.help_outline,
                      size: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            alert,
            style: const TextStyle(color: Colors.red, fontSize: 15),
          ),
          ...widgets,
        ],
      ),
    );
  }
}
