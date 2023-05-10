import 'package:flutter/material.dart';
import 'package:gymapp/services/appstate.dart';
import 'package:gymapp/services/gym_services.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

class MyReserves extends StatelessWidget {
  MyReserves({Key? key, required this.gym, required this.user, this.state})
      : super(key: key);

  final Gym gym;
  final User user;
  late AppState? state;

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
                    height: heightScreen * 2 / 6,
                    width: widthScreen,
                    child: Image.asset(
                      'assets/images/gym1.jpg',
                      fit: BoxFit.cover,
                    )),
              ]),
              Row(children: [
                SizedBox(
                  height: heightScreen * 4 / 6,
                  width: widthScreen,
                  child: FutureBuilder(
                      future: state!.getGyms(),
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        List gym = snapshot.data ?? [];

                        GymServices g = GymServices();
                        return ListView(
                          children: [
                            //TODO arreglar peticion, tarda mucho
                            if (gym.isNotEmpty)
                              for (String s
                                  in g.getReservesUser(gym.elementAt(0), user))
                                reserveCard(context, widthScreen, s),
                          ],
                        );
                      }),
                )
              ])
            ])));
  }

  Card reserveCard(BuildContext context, double widthScreen, String s) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        color: Colors.red,
        elevation: 1,
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
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          s,
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Fecha de la actividad',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Hora de la actividad',
                          style: TextStyle(
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
  }
}
