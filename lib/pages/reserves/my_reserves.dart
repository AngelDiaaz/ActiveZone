import 'package:flutter/material.dart';
import 'package:gymapp/services/services.dart';
import 'package:gymapp/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

///Clase MyReserves
class MyReserves extends StatefulWidget {
  const MyReserves({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyReserves> createState() => _MyReservesState();
}

class _MyReservesState extends State<MyReserves> {
  late AppState state = AppState();
  List<String> nameActivities = [];
  List<Activity> activities = [];
  bool first = true;
  String dropdownValue = '';
  bool end = false;
  Color buttonAvailable = Colors.white;
  Color buttonEnd = Colors.white60;
  String infoText = 'Lo sentimos no dispones de ninguna reserva';

  ///Metodo que carga las listas con los nombres de las actividades
  Future<bool> loadList() async {
    try {
      activities = await state.getUserActivity(widget.user);

      for (Activity a in activities) {
        //Si el nombre de la actividad no esta ya almacenada en la lista
        if (!nameActivities.contains(a.name)) {
          nameActivities.add(a.name);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);

    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: heightScreen,
            width: widthScreen,
            child: Column(children: [
              Row(children: [
                SizedBox(
                    height: heightScreen * 1 / 6,
                    width: widthScreen,
                    child: Image.asset(
                      'assets/images/gym.jpg',
                      fit: BoxFit.cover,
                    )),
              ]),
              Row(children: [
                SizedBox(
                  height: heightScreen * 5 / 6,
                  width: widthScreen,
                  child: Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: widthScreen / 2,
                          height: heightScreen * 0.1,
                          child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  end = false;
                                  buttonAvailable = Colors.white;
                                  buttonEnd = Colors.white60;
                                });
                              },
                              color: buttonAvailable,
                              minWidth: widthScreen / 2,
                              child: Center(
                                child: Text('Reservas pendientes',
                                    style: TextStyle(
                                        fontSize: heightScreen * 0.02,
                                        wordSpacing: 3,
                                        fontWeight: FontWeight.w600)),
                              )),
                        ),
                        SizedBox(
                          height: heightScreen * 0.1,
                          width: widthScreen / 2,
                          child: MaterialButton(
                              color: buttonEnd,
                              minWidth: widthScreen / 2,
                              onPressed: () {
                                setState(() {
                                  end = true;
                                  buttonAvailable = Colors.white60;
                                  buttonEnd = Colors.white;
                                });
                              },
                              child: Center(
                                child: Text('Reservas finalizadas',
                                    style: TextStyle(
                                        fontSize: heightScreen * 0.02,
                                        wordSpacing: 3,
                                        fontWeight: FontWeight.w600)),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: heightScreen * 0.023,
                    ),
                    FutureBuilder(
                        future: loadList(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          try {
                            if (snapshot.hasData) {
                              //Si es la primera vez que se carga la pagina
                              checkFirstTime();

                              return DropdownButton(
                                value: dropdownValue,
                                icon: Icon(Icons.keyboard_arrow_down_outlined,
                                    color: LoginSettings.loginColor(), size: heightScreen*0.045,),
                                elevation: 16,
                                alignment: Alignment.center,
                                style: TextStyle(
                                    color: LoginSettings.loginColor(),
                                    fontWeight: FontWeight.w500,
                                    fontSize: heightScreen * 0.04),
                                iconSize: 34,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                },
                                items: nameActivities
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          } catch (e) {
                            return Row();
                          }
                        }),
                    SizedBox(
                      height: heightScreen * 0.01,
                    ),
                    const Divider(
                        height: 10,
                        indent: 30,
                        endIndent: 30,
                        color: Colors.black26),
                    SizedBox(
                      height: heightScreen * 0.01,
                    ),
                    SizedBox(
                      height: heightScreen * 0.618,
                      child: FutureBuilder(
                          future: loadList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            try {
                              if (snapshot.hasData) {
                                checkFirstTime();

                                return FutureBuilder<List<Schedule>>(
                                    future: state.getSchedulesForUsers('users',
                                        widget.user.dni, dropdownValue, end),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<Schedule>>
                                            snapshot) {
                                      try {
                                        if (snapshot.hasData) {
                                          List<Schedule> schedules =
                                              snapshot.data!;
                                          if (schedules.isNotEmpty) {
                                            return ListView(
                                              padding: const EdgeInsets.all(2),
                                              children: [
                                                for (int i = 0;
                                                    i < schedules.length;
                                                    i++)
                                                  reserveCard(
                                                      context,
                                                      widthScreen,
                                                      heightScreen,
                                                      dropdownValue,
                                                      schedules.elementAt(i)),
                                              ],
                                            );
                                          } else {
                                            return messageNotReserves(
                                                widthScreen, heightScreen, infoText);
                                          }
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      } catch (e) {
                                        return Row();
                                      }
                                    });
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            } catch (e) {
                              return messageNotReserves(widthScreen, heightScreen, infoText);
                            }
                          }),
                    ),
                  ]),
                )
              ]),
            ])));
  }

  ///Metodo que muestra una alerta indicando que no hay reservas para esa solicitud
  Stack messageNotReserves(double width, double height,String text) {
    return Stack(children: [
      Positioned(
        top: height * 0.08,
        width: width,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,

          title: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(wordSpacing: 2)),
          icon: Icon(Icons.sentiment_dissatisfied_outlined,
              color: Colors.redAccent, size: height * 0.08),
        ),
      ),
    ]);
  }

  ///Metodo que comprueba si la pagina ha sido abierta por primera vez
  void checkFirstTime() {
    if (first) {
      //Si se ha abierto por primera vez, asigno el primer valor de la base de datos por defecto
      if (nameActivities.first.isNotEmpty) {
        dropdownValue = nameActivities.first;
      } else {
        dropdownValue = '';
      }
      first = false;
    }
  }

  ///Metodo que devuelve la carta que muestra la informacion de una actividad ya reservada
  FutureBuilder<String> reserveCard(BuildContext context, double widthScreen,
      double heightScreen, String name, Schedule schedule) {
    return FutureBuilder(
      future: state.getImageActivity(name),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        try {
          if (snapshot.hasData) {
            String image = snapshot.data!;

            return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: SizedBox(
                  width: widthScreen - 12,
                  height: heightScreen * 0.18,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: heightScreen * 0.13,
                                height: heightScreen * 0.13,
                                child: Image.network(image, fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: widthScreen * 0.1,
                            ),
                            Column(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: heightScreen * 0.03,
                                      color: LoginSettings.loginColor(),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: heightScreen * 0.01,
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(schedule.date.toDate()),
                                  style: TextStyle(
                                      fontSize: heightScreen * 0.03,
                                      color: LoginSettings.loginColor(),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: heightScreen * 0.01,
                                ),
                                Text(
                                  schedule.hour,
                                  style: TextStyle(
                                      fontSize: heightScreen * 0.03,
                                      color: LoginSettings.loginColor(),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(width: widthScreen * 0.04),
                            //Si es una reserva que no ha finalizado
                            if (!end)
                              IconButton(
                                  onPressed: () {
                                    showAlertDialog(context, schedule);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: heightScreen * 0.04,
                                  )),
                          ])),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(LoginSettings.loginColor())));
          }
        } catch (e) {
          return Row();
        }
      },
    );
  }

  ///Metodo que muestra una alert para confirmar si quieres eliminar la reserva o no
  showAlertDialog(BuildContext context, Schedule schedule) {
    Widget cancelButton = OutlinedButton(
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),),
      child: Text("No", style: TextStyle(color: LoginSettings.loginColor())),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = OutlinedButton(
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),),
      child: Text("Sí", style: TextStyle(color: LoginSettings.loginColor()),),
      onPressed: () async {
        //Le restamos al horario el usuario inscrito
        schedule.numberUsers--;

        await state.deleteScheduleUser(
            dropdownValue, widget.user.dni, schedule);

        //Refrescamos la pantalla para que ya no se muestra esta reserva
        setState(() {});

        if (!mounted) return;
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: const Text("Eliminar reserva"),
      content: const Text("¿Quieres eliminar esta reserva?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
