import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/pages/reserves/my_reserves.dart';
import 'package:gymapp/services/services.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

/// Clase HomePage
class HomePage extends StatefulWidget {
  final Gym gym;
  final User user;
  const HomePage({Key? key, required this.gym, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState? state;

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
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                  height: heightScreen * 2 / 5,
                  width: widthScreen,
                  child: Image.asset(
                    'assets/images/gym.jpg',
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
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn1',
                                        onPressed: () {
                                          if (!mounted) return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyReserves(
                                                  user: widget.user,
                                                )),
                                          );
                                        },
                                        backgroundColor: Colors.white,
                                        child: const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text("Mis reservas",
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NewReserve(
                                                  user: widget.user,
                                                )),
                                          );
                                        },
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
                                          var geolocation = widget.gym.geolocation;

                                          var latitude = geolocation.latitude.toString();
                                          var longitude = geolocation.longitude.toString();

                                          final intent = AndroidIntent(
                                              action: 'action_view',
                                              data: Uri.encodeFull('geo:$latitude,$longitude'),
                                              package: 'com.google.android.apps.maps');
                                          intent.launch();
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
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: FloatingActionButton(
                                        heroTag: 'btn4',
                                        onPressed: () async {
                                          var instagram = widget.gym.instagram;
                                          final intent = AndroidIntent(
                                              action: 'action_view',
                                              data: Uri.encodeFull('http://instagram.com/$instagram'),
                                              package: 'com.instagram.android');
                                          intent.launch();
                                        },
                                        backgroundColor: Colors.white,
                                        child: const Icon(
                                          Icons.public,
                                          color: Colors.black,
                                          size: 40,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  const Text("Instagram",
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