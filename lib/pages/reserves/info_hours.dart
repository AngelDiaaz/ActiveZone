import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'confirm_reserve.dart';

class InfoHours extends StatefulWidget {
  final String activityName;
  final User user;

  const InfoHours({Key? key, required this.activityName, required this.user})
      : super(key: key);

  @override
  State<InfoHours> createState() => _InfoHoursState();
}

class _InfoHoursState extends State<InfoHours> {
  var index = 0;
  AppState state = AppState();
  double width = 0;
  Schedule schedule =
      Schedule(id: '', hour: '', numberUsers: 0, date: Timestamp(0, 0));
  TextEditingController dateController = TextEditingController();
  List<Schedule> schedules = [];
  DateTime? pickedDate = DateTime.now();
  bool first = true;

  @override
  Widget build(BuildContext context) {
    var pages = [
      infoHours(),
      ConfirmReserve(
        schedule: schedule,
        activityName: widget.activityName,
        user: widget.user,
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
          Center(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
                child: Text(
                  widget.activityName,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                )),
          ),
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black54),
          selectDate(),
          const SizedBox(
            height: 20,
          ),
          const Divider(
              height: 10, indent: 10, endIndent: 10, color: Colors.black87),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: state.getActivity(widget.activityName),
            builder: (context, snapshot) {
              try {
                if (snapshot.hasData) {
                  if (schedules.isNotEmpty) {
                    Activity activity = snapshot.data!;

                    return printHours(schedules, activity.capacity);
                  } else {
                    return const AlertDialog(
                      title: Text(
                          'No hay actividades disponibles para esta fecha',
                          textAlign: TextAlign.center,
                          style: TextStyle(wordSpacing: 2)),
                      icon: Icon(Icons.priority_high,
                          color: Colors.redAccent, size: 50),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              } catch (e) {
                return Row();
              }
            },
          ),
        ]);
  }

  ///Metodo que contiene el widget para seleccionar la fecha que queremos de una actividad
  Container selectDate() {
    if (first) {
      dateController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
      pickedDate = DateTime.now();
      first = false;
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 25, 15),
      child: FutureBuilder(
        future: signup(Timestamp.fromDate(pickedDate!)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today, color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: Colors.black,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 20),
                readOnly: true,
                onTap: () async {
                  pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2023, 12, 31));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate!);
                    setState(() {
                      dateController.text = formattedDate;
                    });
                    //await signup(Timestamp.fromDate(pickedDate!));
                  }
                  loadSchedules(Timestamp.fromDate(pickedDate!));
                  //Vuelvo a refrescar la pagina para que me aparezca los horarios correspondientes
                  setState(() {});
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  //TODO controlar hora para mostrar horarios

  ///Metodo que devuelve una lista con las fechas de los horarios
  List<String> seeDate(List<Schedule> schedules) {
    List<String> dates = [];

    for (Schedule s in schedules) {
      if (!dates.contains(DateFormat('dd/MM/yyyy').format(s.date.toDate()))) {
        dates.add(DateFormat('dd/MM/yyyy').format(s.date.toDate()));
      }
    }
    return dates;
  }

  ///Metodo que obtiene los horarios de una fecha concreta
  FutureBuilder loadSchedules(Timestamp date) {
    Timestamp finalDate =
        Timestamp.fromDate(date.toDate().add(const Duration(days: 1)));
    return FutureBuilder(
      future: state.getShedulesByDate(date, widget.activityName, finalDate),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          schedules = snapshot.data!;
        }
        setState(() {});
        return const SizedBox();
      },
    );
  }

  Future<List<Schedule>> signup(Timestamp date) async {
    Timestamp finalDate =
        Timestamp.fromDate(date.toDate().add(const Duration(days: 1)));

    schedules =
        await state.getShedulesByDate(date, widget.activityName, finalDate);

    return schedules;
  }

  /// Metodo que imprime todas las horas de una clase
  Column printHours(List<Schedule> schedules, int activityCapacity) {
    // Para saber cuantas filas hacen falta
    var rows = schedules.length / 3;
    var count = 0;
    List<Schedule> s = state.getAvailableSchedules(schedules, activityCapacity);
    return Column(
      children: [
        for (int i = 0; i < rows; i++) ...[
          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                if (count + 1 <= s.length) ...[
                  Container(
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
