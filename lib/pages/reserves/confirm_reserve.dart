import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/services/services.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';

/// Clase ConfirmReserve
class ConfirmReserve extends StatefulWidget {
  final Schedule schedule;
  final String activityName;
  final User user;

  const ConfirmReserve({
    Key? key,
    required this.schedule,
    required this.activityName,
    required this.user,
  }) : super(key: key);

  @override
  State<ConfirmReserve> createState() => _ConfirmReserveState();
}

class _ConfirmReserveState extends State<ConfirmReserve> {
  double width = 0;
  Color buttonColor = const Color.fromRGBO(114, 76, 45, 1);
  AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Row(
        children: [
          SizedBox(
            height: heightScreen * 4 / 6,
            width: widthScreen,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  showInfo('Clase:', widget.activityName),
                  const SizedBox(
                    height: 10,
                  ),
                  divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  showInfo(
                      'Fecha:',
                      DateFormat('dd/MM/yyyy')
                          .format(widget.schedule.date.toDate())),
                  const SizedBox(
                    height: 10,
                  ),
                  divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  showInfo('Hora:', widget.schedule.hour),
                  const SizedBox(
                    height: 10,
                  ),
                  divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  showInfo('Duración:', widget.schedule.duration!),
                  const SizedBox(
                    height: 10,
                  ),
                  divider(),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      height: heightScreen * 1 / 16,
                      width: width * 3 / 5,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () async {
                          Gym gym = await state.getGym();
                          Activity a = await state.getActivity(widget.activityName);
                          a.schedule!.clear();
                          widget.schedule.numberUsers++;

                          state.insertUserActivity(
                              a, widget.schedule, widget.user);

                          if (!mounted) return;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        gym: gym,
                                        user: widget.user,
                                      )));
                        },
                        child: const Text('Confirmar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: heightScreen * 1 / 16,
                      width: width * 3 / 5,
                      decoration: BoxDecoration(
                          border: Border.all(color: buttonColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoNewReserve(
                                        user: widget.user,
                                        activityName: widget.activityName,
                                      )));
                        },
                        child: Text('Cancelar',
                            style: TextStyle(color: buttonColor, fontSize: 20)),
                      ),
                    ),
                  )
                ]),
          ),
        ],
      )
    ]);
  }

  /// Metodo que muestra la informacion de un campo
  Row showInfo(String title, String information) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width * 2 / 5,
          height: 50,
          child: Center(
              child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          )),
        ),
        Container(
          width: width * 3 / 5,
          height: 50,
          alignment: Alignment.centerLeft,
          child: Text(
            information,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  /// Metodo que devuelve un  divider
  Divider divider() {
    return const Divider(
        height: 10, indent: 20, endIndent: 20, color: Colors.black26);
  }
}
