import 'package:flutter/material.dart';
import 'package:gymapp/services/appstate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

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
  Color buttonEnd = Colors.white70;
  String infoEmptyText = '';

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
    if (first) infoEmptyText = 'hola';

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
                      'assets/images/gym1.jpg',
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
                          height: 80,
                          child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  end = false;
                                  buttonAvailable = Colors.white;
                                  buttonEnd = Colors.white70;
                                  infoEmptyText =
                                      'Lo sentimos no dispones de ninguna reserva pendiente para esta actividad';
                                });
                              },
                              color: buttonAvailable,
                              minWidth: widthScreen / 2,
                              child: const Center(
                                child: Text('Reservas pendientes',
                                    style: TextStyle(
                                        fontSize: 18, wordSpacing: 2)),
                              )),
                        ),
                        SizedBox(
                          height: 80,
                          width: widthScreen / 2,
                          child: MaterialButton(
                              color: buttonEnd,
                              minWidth: widthScreen / 2,
                              onPressed: () {
                                setState(() {
                                  end = true;
                                  buttonAvailable = Colors.white70;
                                  buttonEnd = Colors.white;
                                  infoEmptyText =
                                      'Lo sentimos no dispones de ninguna reserva finalizada para esta actividad';
                                });
                              },
                              child: const Center(
                                child: Text('Reservas finalizadas',
                                    style: TextStyle(
                                        fontSize: 18, wordSpacing: 2)),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
                                icon: const Icon(Icons.arrow_downward,
                                    color: Colors.black),
                                elevation: 16,
                                alignment: Alignment.centerLeft,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                        height: 10,
                        indent: 30,
                        endIndent: 30,
                        color: Colors.black26),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: heightScreen * 4 / 6 - 60,
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
                                                      dropdownValue,
                                                      schedules.elementAt(i)),
                                              ],
                                            );
                                          } else {
                                            return messageNotReserves(
                                                widthScreen, infoEmptyText);
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
                              return messageNotReserves(widthScreen,
                                  'Lo sentimos no dispones de ninguna reserva pendiente, ni finalizada');
                            }
                          }),
                    ),
                  ]),
                )
              ]),
            ])));
  }

  ///Metodo que muestra una alerta indicando que no hay reservas para esa solicitud
  Stack messageNotReserves(double width, String text) {
    return Stack(children: [
      Positioned(
        top: 80,
        width: width,
        child: AlertDialog(
          title: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(wordSpacing: 2)),
          icon: const Icon(Icons.sentiment_dissatisfied_outlined,
              color: Colors.redAccent, size: 50),
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
      String name, Schedule schedule) {
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
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                child: SizedBox(
                  width: widthScreen - 12,
                  height: 150,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Row(children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(image, fit: BoxFit.cover),
                            ),
                            SizedBox(
                              width: widthScreen / 2 - 155,
                            ),
                            Column(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(schedule.date.toDate()),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  schedule.hour,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            if (!end)
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: FutureBuilder(
                                  future: state.getActivity(dropdownValue),
                                  builder: (context, snapshot) {
                                    return IconButton(
                                        onPressed: () async {

                                          //TODO terminar funcionalidad de eliminar horario

                                          state.deleteScheduleUser(snapshot.data!, widget.user.dni, schedule);

                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 30,)),

                                  },
                                ),
                              ),
                          ])),
                    ],
                  ),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } catch (e) {
          return Row();
        }
      },
    );
  }
}
