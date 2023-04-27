import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'confirm_reserve.dart';

class ChooseHour extends StatefulWidget {
  Activity activity;
  ChooseHour({Key? key, required this.activity}) : super(key: key);

  @override
  State<ChooseHour> createState() => _ChooseHourState();
}

class _ChooseHourState extends State<ChooseHour> {
  double width = 0;
  int index = 0;
  Schedule schedule = Schedule(hour: '');

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var schedules = widget.activity.schedule!;
    final pages = [
      ChooseHour(activity: widget.activity),
      ConfirmReserve(schedule: schedule, activity: widget.activity,)
    ];
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
            height: 20,
          ),
          printHours(widget.activity.schedule!),
        ]);
  }

  /// Metodo que imprime todas las horas de una clase
  Column printHours(List<Schedule> schedules) {
    // Para saber cuantas filas hacen falta
    var rows = schedules.length / 3;
    var count = 0;
    return Column(
      children: [
        for (int i = 0; i < rows; i++) ...[
          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                Container(
                  // Si no hay mas horarios imprime una columna vacia
                    child: count + 1 <= schedules.length
                        ? hourButton(schedules.elementAt(count++))
                        : Column()),
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

