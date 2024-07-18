import 'package:app/src/data/templates.data.dart';
import 'package:app/src/models/progressIndicator.model.dart';
import 'package:flutter/material.dart';

class SaveButtonWidget extends StatefulWidget {
  final Templates template;

  const SaveButtonWidget({
    super.key,
    required this.template,
  });

  @override
  State<SaveButtonWidget> createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget> {
  bool isSaving = false; // Track the saving state
  bool isSuccess = false;
  Text _dialogMessage =
      const Text('Are you sure you want to submit this inspection?');
  int resState = 0;

  void _submitInspection(BuildContext context, StateSetter setState) async {
    setState(() {
      isSaving = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );

    Map<String, dynamic> success = await Future.delayed(
      const Duration(seconds: 1),
      () => widget.template.saveInspection(),
    );
    // print(success['state']);

    if (mounted) {
      setState(() {
        isSaving = false;
        resState = success['state'];
        resState == 200 ? isSuccess = true : isSuccess = false;
        // isSuccess = success['state'];
        _dialogMessage = success['msg'];
      });
    }
  }

  void initDialog() {
    _dialogMessage =
        const Text('Are you sure you want to submit this inspection?');
    isSaving = false;
    isSuccess = false;
    resState = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.25, 50),
          elevation: 5,
          shadowColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              // _dialogMessage = const Text(
              //     'Are you sure you want to submit this inspection?');
              initDialog();
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Submit Inspection'),
                    content: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 24,
                            child: CustomProgressIndicator(
                              size: 20,
                              color: Colors.blue,
                              duration: Duration(seconds: 2),
                              strokeWidth: 2.0,
                              type: ProgressIndicatorType.circular,
                            ),
                          )
                        : _dialogMessage,
                    actions: (!isSaving && !isSuccess)
                        ? <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            if (resState == 0)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  _submitInspection(context, setState);
                                },
                                child: const Text(
                                  'Save Inspection',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ]
                        : (!isSaving && isSuccess)
                            ? <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/", (r) => false);
                                  },
                                  child: const Text('Ok'),
                                ),
                              ]
                            : <Widget>[],
                  );
                },
              );
            },
          );
        },
        child: const Text('Submit'),
      ),
    );
  }
}
