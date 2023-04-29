import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/services/appstate.dart';
import '../../models/models.dart';

/// Clase InfoNewReserve
class InfoNewReserve extends StatefulWidget {
  final Activity activity;
  final User? user;
  final Gym? gym;

  const InfoNewReserve({Key? key, required this.activity, this.user, this.gym})
      : super(key: key);

  @override
  State<InfoNewReserve> createState() => _InfoNewReserveState();
}

class _InfoNewReserveState extends State<InfoNewReserve> {
  double width = 0;
  int index = 0;
  Schedule schedule = Schedule(hour: '');
  AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;
    var schedules = widget.activity.schedule!;
    final pages = [
      infoHours(widthScreen, schedules),
      ConfirmReserve(
        schedule: schedule,
        activity: widget.activity,
        user: widget.user,
        gym: widget.gym,
      )
    ];
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
                  child: pages[index],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column infoHours(double widthScreen, List<Schedule> schedules) {
    var items = seeDate(schedules);
    String choose = schedules.elementAt(0).date!;
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
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,10,10,30),
              child: DropdownButton(
                value: choose,
                style: const TextStyle(fontSize: 30, color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    choose = newValue!;
                  });
                },
              ),
            ),
          ),
          //TODO mostrar divider bien arreglar y consulta fecha
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black54),
          const SizedBox(
            height: 20,
          ),
          printHours(schedules, widget.activity.capacity),
        ]);
  }

  List<String> seeDate(List<Schedule> schedules) {
    List<String> dates = [];

    for (Schedule s in schedules) {
      if (!dates.contains(s.date)) dates.add(s.date!);
    }
    return dates;
  }

  /// Metodo que imprime todas las horas de una clase
  Column printHours(List<Schedule> schedules, int activityCapacity) {
    // Para saber cuantas filas hacen falta
    var rows = schedules.length / 3;
    var count = 0;
    List<Schedule> s = state.getAvailableSchedules(widget.activity);
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
