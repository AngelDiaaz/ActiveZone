import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'confirm_reserve.dart';

class InfoHours extends StatefulWidget {
  final Activity activity;
  final User? user;
  final Gym? gym;

  const InfoHours({Key? key, required this.activity, this.user, this.gym})
      : super(key: key);

  @override
  State<InfoHours> createState() => _InfoHoursState();
}

class _InfoHoursState extends State<InfoHours> {
  var index = 0;
  AppState state = AppState();
  double width = 0;
  Schedule schedule = Schedule(hour: '');
  TextEditingController dateController = TextEditingController();
  List<Schedule> s = [];

  @override
  Widget build(BuildContext context) {
    var pages = [
      infoHours(),
      ConfirmReserve(
        schedule: schedule,
        activity: widget.activity,
        user: widget.user,
        gym: widget.gym,
      )
    ];
    width = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    return SizedBox(
      height: heightScreen * 4 / 6,
      width: width,
      child: pages[index],
    );
  }

  Column infoHours() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: width,
                child: Center(
                  //TODO arreglar fallo con mostrar el nombre al abrir
                    child: Text(
                  widget.activity.name,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
              ),
            ],
          ),
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black54),
          selectDate(),
          const SizedBox(
            height: 10,
          ),
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black87),
          const SizedBox(
            height: 10,
          ),
          printHours(s, widget.activity.capacity),
        ]);
  }

  ///Metodo que contiene el widget para seleccionar la fecha que queremos de una actividad
  Container selectDate() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 25, 15),
      child: TextField(
          controller: dateController,
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            labelText: "Introduce fecha",
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusColor: Colors.black,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 20),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2023, 12, 31));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
              setState(() {
                dateController.text = formattedDate;
              });
            }
            await signup(dateController.text);
            //Vuelvo a refrescar la pagina para que me aparezca sus horarios correspondientes
            setState(() {});
          }),
    );
  }

  ///Metodo que devuelve una lista con las fechas de los horarios
  List<String> seeDate(List<Schedule> schedules) {
    List<String> dates = [];

    for (Schedule s in schedules) {
      if (!dates.contains(s.date)) dates.add(s.date!);
    }
    return dates;
  }

  ///Metodo que obtiene los horarios de una fecha concreta
  Future<void> signup(String date) async {
    s = await state.getShedulesByDate(
        date, widget.gym!.id, widget.activity.name);
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
        //TODO arreglar boton abrir
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