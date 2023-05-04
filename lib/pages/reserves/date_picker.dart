import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/appstate.dart';

// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       restorationScopeId: 'app',
//       title: _title,
//       home: DatePicker(restorationId: 'main'),
//     );
//   }
// }

class DatePicker extends StatefulWidget {
  DatePicker({super.key, this.restorationId, this.gym, this.activity});

  final String? restorationId;
  static String? date;
  final List<Schedule> s = [];
  final Gym? gym;
  final Activity? activity;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> with RestorationMixin {
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
  AppState appState = AppState();
  String date = '11/05/2023';
  List<Schedule> s = [];

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now(),
          lastDate: DateTime(2023, 12, 31),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
      signup();
      date =
          '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
    }
  }

  Future<void> signup() async {
    s = await appState.getShedulesByDate(date, widget.gym!.id, widget.activity!.name);
    print(s);
    print('object');
    print(date);
  }

  List<Schedule> getS(){
    return s;
  }

  //TODO mirar si puedo actualizarlo desde aqui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: signup(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Center(
            child: OutlinedButton(
              onPressed: () async {
                _restorableDatePickerRouteFuture.present();
              },
              child: const Text('Seleccionar fecha'),
            ),
          );
        },
      ),
    );
  }
}
