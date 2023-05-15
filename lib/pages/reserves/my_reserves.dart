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
                      'assets/images/gym1.jpg',
                      fit: BoxFit.cover,
                    )),
              ]),
              Row(children: [
                SizedBox(
                  height: heightScreen * 5 / 6,
                  width: widthScreen,
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'Mis reservas',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                        height: 10,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.black26),
                    const SizedBox(
                      height: 10,
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    const Divider(
                        height: 10,
                        indent: 30,
                        endIndent: 30,
                        color: Colors.black26),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: heightScreen * 4 / 6 - 20,
                      child: FutureBuilder(
                          future: loadList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            try {
                              if (snapshot.hasData) {
                                checkFirstTime();

                                return FutureBuilder<List<Schedule>>(
                                    future: state.getSchedules('users',
                                        widget.user.dni, dropdownValue),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<Schedule>>
                                            snapshot) {
                                      try {
                                        if (snapshot.hasData) {
                                          List<Schedule> schedules =
                                              snapshot.data!;

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
                              return const AlertDialog(
                                title: Text('Lo sentimos no dispones de ninguna reserva pendiente',textAlign: TextAlign.center, style: TextStyle(wordSpacing: )),
                                icon: Icon(Icons.sentiment_dissatisfied_outlined, color:  Colors.redAccent,size: 50),
                              );
                            }
                          }),
                    ),
                  ]),
                )
              ]),
            ])));
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
                              width: widthScreen / 2 - 130,
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
