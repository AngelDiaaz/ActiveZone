import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Clase ChooseHour
class ChooseHour extends StatefulWidget {
  final Activity activity;

  const ChooseHour({Key? key, required this.activity}) : super(key: key);

  @override
  State<ChooseHour> createState() => _ChooseHourState();
}

class _ChooseHourState extends State<ChooseHour> {
  double width = 0;
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;
    var schedules = widget.activity.schedule!;
    return Scaffold(
      body: SizedBox(
        width: widthScreen,
        height: heightScreen,
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                height: heightScreen * 2 / 6,
                width: widthScreen,
                child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.activity.image)),
              ),
            ]),
            Row(
              children: [
                SizedBox(
                  height: heightScreen * 4 / 6,
                  width: widthScreen,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            printHours(schedules),
                          ],
                        ),
                        // for (Schedule schedule in schedules) rowA(schedule),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      width: width/3 - 30,
      height: 60,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: TextButton(
        onPressed: () {},
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
