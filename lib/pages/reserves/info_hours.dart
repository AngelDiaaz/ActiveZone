import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import 'date_picker.dart';

class InfoHours extends StatefulWidget {
  final Activity activity;
  final User? user;
  final Gym? gym;

  const InfoHours({Key? key, required this.activity, this.user, this.gym}) : super(key: key);

  @override
  State<InfoHours> createState() => _InfoHoursState();
}

class _InfoHoursState extends State<InfoHours> {
  var index = 0;
  AppState state = AppState();
  double width = 0;
  Schedule schedule = Schedule(hour: '');
  List<Schedule> a = DatePicker().s;
  @override
  Widget build(BuildContext context) {
    print(a);
    print('aaaaaa');
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: widthScreen,
                child: Center(
                    child: Text(
                  widget.activity.name,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black54),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: SizedBox(width: 200, height: 100, child: DatePicker(activity: widget.activity,gym: widget.gym,)),
          ),

          //TODO mostrar divider bien arreglar y consulta fecha
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black54),
          const SizedBox(
            height: 20,
          ),
          printHours(a, widget.activity.capacity),
        ]);
  }

  // Future<void> signup() async {
  //   a = await state.getShedulesByDate(
  //       DatePicker.date!, widget.gym!.id, widget.activity.name);
  //   print(a);
  // }

  ///Metodo que devuelve una lista con las fechas de los horarios
  List<String> seeDate(List<Schedule> schedules) {
    List<String> dates = [];

    for (Schedule s in schedules) {
      if (!dates.contains(s.date)) dates.add(s.date!);
    }
    print('hola');
    print(DatePicker.date);
    return dates;
  }

  /// Metodo que imprime todas las horas de una clase
  Column printHours(List<Schedule> schedules, int activityCapacity) {
    // Para saber cuantas filas hacen falta
    var rows = schedules.length / 3;
    var count = 0;
    List<Schedule> s =
        state.getAvailableSchedules(schedules, widget.activity.capacity);
    return Column(
      children: [
        for (int i = 0; i < rows; i++) ...[
          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                if (count + 1 <= s.length) ...[
                  Container(
                    // Si no hay mas horarios imprime una columna vacia
                    child: hourButton(s.elementAt(count++)),
                  ),
                ]
              ],
            ],
          ),
        ],
      ],
    );
  }

  /// Metodo que devuelve un boton con la hora de una clase
  Container hourButton(Schedule schedule) {
    return Container(
      width: width / 3 - 30,
      height: 65,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(2.0),
      child: TextButton(
        onPressed: () {
          this.schedule = schedule;
          setState(() {
            index = 1;
          });
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black26, // your color here
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2)))),
        child: Text(
          schedule.hour,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
