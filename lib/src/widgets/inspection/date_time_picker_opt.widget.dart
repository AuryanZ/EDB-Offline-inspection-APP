import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerExample extends StatefulWidget {
  final ValueChanged<DateTime?> onDateChanged;
  final String? restorationId;
  const DatePickerExample(
      {super.key, this.restorationId, required this.onDateChanged});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerExampleState extends State<DatePickerExample>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2200),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        widget.onDateChanged(_selectedDate.value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.50,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          _restorableDatePickerRouteFuture.present();
        },
        child: Text(
          'Selected: ${DateFormat('dd/MMMM/yyyy').format(_selectedDate.value)}',
        ),
        // child: Text(
        //   'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}',
        // ),
      ),
    );
  }
}
