import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import '../../models/models.dart';

/// Clase ConfirmReserve
class ConfirmReserve extends StatefulWidget {
  final Schedule schedule;
  final Activity activity;

  const ConfirmReserve({
    Key? key,
    required this.schedule,
    required this.activity,
  }) : super(key: key);

  @override
  State<ConfirmReserve> createState() => _ConfirmReserveState();
}

class _ConfirmReserveState extends State<ConfirmReserve> {
  double width = 0;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;
    Color buttonColor = const Color.fromRGBO(114, 76, 45, 1);

    //TODO arreglar vuelta atras con setState
    final pages = [
      // ChooseHour(activity: activity).infoHours(widthScreen, schedules),
      ConfirmReserve(
        schedule: widget.schedule,
        activity: widget.activity,
      )
    ];
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
                  showInfo('Clase:', widget.activity.name),
                  const SizedBox(
                    height: 10,
                  ),
                  divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  showInfo('Fecha:', widget.schedule.date!),
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
                    height: 45,
                  ),
                  Center(
                    child: Container(
                      height: 48,
                      width: 220,
                      decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () {},
                        child: const Text('Confirmar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      height: 48,
                      width: 220,
                      decoration: BoxDecoration(
                          border: Border.all(color: buttonColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InfoNewReserve(
                                      activity: widget.activity,
                                    )),
                          );
                          setState(() {
                            index = 0;
                          });
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

  /// Metodo que inserta el divider de la pestaña
  Divider divider() {
    return const Divider(
        height: 10, indent: 20, endIndent: 20, color: Colors.black26);
  }
}
