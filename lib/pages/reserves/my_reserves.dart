import 'package:flutter/material.dart';
import 'package:gymapp/services/appstate.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';

class MyReserves extends StatelessWidget {
  MyReserves({Key? key, required this.user, this.state})
      : super(key: key);

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
                  child: FutureBuilder<User>(
                      future: state!.getReservesUser(user.dni),
                      builder:
                          (BuildContext context, AsyncSnapshot<User> snapshot) {
                        print(snapshot.data.toString());
                        User? u;
                        if(snapshot.hasData){
                          u = snapshot.data;

                        return ListView(
                          children: [
                            if (u != null)
                              for(int i = 0; i < u.activity!.length; i++)
                                for(int j = 0; j > u.activity!.elementAt(i).schedule!.length; j++)
                                  reserveCard(context, widthScreen, u.activity!.elementAt(i).name, u.activity!.elementAt(i).schedule!.elementAt(j)),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                        }
                          }),
                )
              ])
            ])));
  }

  Card reserveCard(BuildContext context, double widthScreen, String name, Schedule schedule) {
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
                          name,
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
