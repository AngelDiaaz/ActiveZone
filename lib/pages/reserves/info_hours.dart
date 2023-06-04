import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'package:gymapp/pages/pages.dart';
import '../../utils/utils.dart';

///Clase InfoHours
class InfoHours extends StatefulWidget {
  final String activityName;
  final User user;

  const InfoHours({Key? key, required this.activityName, required this.user})
      : super(key: key);

  @override
  State<InfoHours> createState() => _InfoHoursState();
}

class _InfoHoursState extends State<InfoHours> {
  AppState state = AppState();
  int index = 0;
  double widthScreen = 0;
  double heightScreen = 0;
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
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return SizedBox(
      height: heightScreen * 4 / 6,
      width: widthScreen,
      child: pages[index],
    );
  }

  Column infoHours() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 10),
            child: Text(
              widget.activityName,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: AppSettings.mainColor()),
            )),
      ),
      const Divider(
          height: 10, indent: 20, endIndent: 20, color: Colors.black54),
      selectDate(),
      const Divider(
          height: 10, indent: 20, endIndent: 20, color: Colors.black54),
      SizedBox(
        height: heightScreen * 0.01,
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
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 10,
                  title: const Text('No hay actividades disponibles para esta fecha',
                      textAlign: TextAlign.center,
                      style: TextStyle(wordSpacing: 2)),
                  icon: Icon(Icons.priority_high,
                      color: Colors.redAccent, size: heightScreen * 0.07),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppSettings.loginColor())));
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
        future: loadSchedules(Timestamp.fromDate(pickedDate!)),
        builder: (context, snapshot) {
          try {
          if (snapshot.hasData) {
            return TextField(
                controller: dateController,
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today, color: AppSettings.mainColor(), size: heightScreen * 0.04),
                  labelStyle: TextStyle(color: AppSettings.mainColor()),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusColor: AppSettings.mainColor(),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppSettings.mainColor(), fontSize: heightScreen * 0.03),
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
                  } else {
                    dateController.text =
                        DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                    pickedDate = DateTime.now();
                  }
                  //Vuelvo a refrescar la pagina para que me aparezca los horarios correspondientes
                  setState(() {});
                });
          } else {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppSettings.loginColor())));
          }} catch (e) {
            return Row();
          }
        },
      ),
    );
  }

  ///Metodo que carga los horarios de una fecha concreta
  Future<List<Schedule>> loadSchedules(Timestamp date) async {
    //Le sumo un dia a la fecha que le paso, para traerme los horarios entre esa fecha y el dia siguiente
    Timestamp finalDate =
        Timestamp.fromDate(DateTime(date.toDate().year, date.toDate().month, date.toDate().day + 1, 0, 0, 0));

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
                  hourButton(s.elementAt(count++)),
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
      width: widthScreen * 0.257,
      height: heightScreen * 0.08,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () async {
          bool find = false;

          //Obtengo los horarios en los que esta apuntado el usuario
          List<Schedule> schedules = await state.getSchedulesForUsers(
              'users', widget.user.dni, widget.activityName, false);

          //Compruebo si esta inscrito o no en ese horario
          for (Schedule s in schedules) {
            if (s.id == schedule.id) {
              find = true;
            }
          }

          //Si no esta inscrito
          if (!find) {
            //Para luego cargar ese horario con la informacion detallada
            this.schedule = schedule;
            setState(() {
              index = 1;
            });
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ya estás inscrito en esta actividad',
                    textAlign: TextAlign.center,
                    style: TextStyle(wordSpacing: 2)),
                icon: Icon(Icons.sentiment_satisfied_alt_outlined,
                    color: Colors.green, size: heightScreen * 0.075),
              ),
            );
          }
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black26, // your color here
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8)))),
        child: Text(
          schedule.hour,
          style: TextStyle(
              fontSize: heightScreen * 0.027, fontWeight: FontWeight.w500, color: AppSettings.mainColor()),
        ),
      ),
    );
  }
}
