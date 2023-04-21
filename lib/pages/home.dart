import 'package:flutter/material.dart';
import 'package:gymapp/services/appstate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: heightScreen,
        width: widthScreen,
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                  height: heightScreen * 2 / 5,
                  width: widthScreen,
                  child: Image.asset(
                    'assets/images/gym1.jpg',
                    fit: BoxFit.cover,
                  )),
            ]),
            Row(
              children: [
                SizedBox(
                  height: heightScreen * 3 / 5,
                  width: widthScreen,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: (heightScreen * 3 / 5) / 3,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn1',
                                        onPressed: null,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Text("Mis reservas",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: (heightScreen * 3 / 5) / 2,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn2',
                                        onPressed: () =>
                                            Navigator.pushNamed(context, 'new'),
                                        backgroundColor: Colors.white,
                                        child: const Icon(
                                          Icons.edit_calendar_outlined,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text("Nueva reserva",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: (heightScreen * 3 / 5) / 3,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn3',
                                        onPressed: () async {
                                          AppState a = AppState();

                                          var b = await a.getGyms();
                                          print(b.elementAt(0).activities.elementAt(1).name);

                                        },
                                        backgroundColor: Colors.white,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text("Gimnasio",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: (heightScreen * 3 / 5) / 3,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn4',
                                        onPressed: null,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.public,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Text("Instagram",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}