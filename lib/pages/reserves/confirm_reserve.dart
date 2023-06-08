import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/services/services.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../utils/page_settings.dart';

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
  AppState state = AppState();
  double widthScreen = 0;
  double heightScreen = 0;

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

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
                  separate(),
                  showInfo('Clase:', widget.activityName),
                  separate(),
                  divider(),
                  separate(),
                  showInfo(
                      'Fecha:',
                      DateFormat('dd/MM/yyyy')
                          .format(widget.schedule.date.toDate())),
                  separate(),
                  divider(),
                  separate(),
                  showInfo('Hora:', widget.schedule.hour),
                  separate(),
                  divider(),
                  separate(),
                  showInfo('Duración:', widget.schedule.duration!),
                  separate(),
                  divider(),
                  SizedBox(
                    height: heightScreen * 0.05,
                  ),
                  Center(
                    child: Container(
                      height: heightScreen * 0.075,
                      width: widthScreen * 0.6,
                      decoration: BoxDecoration(
                          color: AppSettings.mainColor(),
                          borderRadius: BorderRadius.circular(15)),
                      child: MaterialButton(
                        onPressed: () async {
                          Activity a =
                              await state.getActivity(widget.activityName);
                          a.schedule!.clear();
                          widget.schedule.numberUsers++;

                          state.insertUserActivity(
                              a, widget.schedule, widget.user);

                          //Muestro el mensaje de que se ha confirmado la reserva
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0))),
                              contentPadding:
                              EdgeInsets.only(top: 20.0),
                              title: Text(
                                  'Te has apuntado a la actividad',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(wordSpacing: 2)),
                              icon: Icon(Icons.task_alt_outlined,
                                  color: Colors.green, size: 50),
                              backgroundColor:
                              Color.fromRGBO(247, 237, 240, 1),
                            ),
                          );
                          //Hago que se muestra el mensaje de la activacion durante dos segundos
                          await Future.delayed(
                              const Duration(seconds: 2));

                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    user: widget.user,
                                  )
                              ),
                              ModalRoute.withName("/")
                          );
                        },
                        child: Text('Confirmar',
                            style:
                                TextStyle(color: Colors.white, fontSize: heightScreen * 0.03)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightScreen * 0.025,
                  ),
                  Center(
                    child: Container(
                      height: heightScreen * 0.075,
                      width: widthScreen * 0.6,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppSettings.mainColor()),
                          borderRadius: BorderRadius.circular(10)),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InfoNewReserve(
                                    user: widget.user,
                                    activityName: widget.activityName,
                                  )
                              ),
                              ModalRoute.withName("/")
                          );
                        },
                        child: Text('Cancelar',
                            style: TextStyle(color: AppSettings.mainColor(), fontSize: heightScreen * 0.03)),
                      ),
                    ),
                  )
                ]),
          ),
        ],
      )
    ]);
  }

  /// Metodo que devuelve el espacio que hay entre los textos
  SizedBox separate() {
    return SizedBox(
      height: heightScreen * 0.016,
    );
  }

  /// Metodo que muestra la informacion de un campo
  Row showInfo(String title, String information) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widthScreen * 0.4,
          height: heightScreen * 0.05,
          child: Center(
            child: Text(title,
                style: TextStyle(
                  fontSize: heightScreen * 0.028,
                  fontWeight: FontWeight.w400, color: AppSettings.mainColor()
                )),
          ),
        ),
        Container(
          width: widthScreen * 0.5,
          height: heightScreen * 0.05,
          alignment: Alignment.center,
          child: Text(
            information,
            style: TextStyle(
              fontSize: heightScreen * 0.028,
              fontWeight: FontWeight.w400, color: AppSettings.mainColor()),
          ),
        ),
      ],
    );
  }

  /// Metodo que devuelve un  divider
  Divider divider() {
    return Divider(
        height: heightScreen *0.012, indent: 20, endIndent: 20, color: AppSettings.mainColor());
  }
}
