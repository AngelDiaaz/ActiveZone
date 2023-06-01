import 'dart:io';
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

  const HomePage({Key? key, required this.gym, required this.user})
      : super(key: key);

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
    var heightContainer = heightScreen * 0.22;
    var textSize = widthScreen * 0.05;
    var sizeMargin = heightScreen * 0.025;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: heightScreen,
        width: widthScreen,
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                  height: heightScreen * 0.35,
                  width: widthScreen,
                  child: Image.asset(
                    'assets/images/gym.jpg',
                    fit: BoxFit.cover,
                  )),
            ]),
            Row(
              children: [
                SizedBox(
                  height: heightScreen * 0.65,
                  width: widthScreen,
                  child: Column(
                    children: [
                      SizedBox(height: heightScreen *  0.01,),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: heightContainer,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.1,
                                    width: heightScreen * 0.1,
                                    child: FloatingActionButton(
                                        heroTag: 'btn1',
                                        onPressed: () {
                                          if (!mounted) return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyReserves(
                                                      user: widget.user,
                                                    )),
                                          );
                                        },
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.black,
                                          size: heightScreen * 0.06,
                                        )),
                                  ),
                                  SizedBox(
                                    height: sizeMargin,
                                  ),
                                  Text("Mis reservas",
                                      style: TextStyle(fontSize: textSize)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: heightContainer,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.1,
                                    width: heightScreen * 0.1,
                                    child: FloatingActionButton(
                                        heroTag: 'btn2',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewReserve(
                                                      user: widget.user,
                                                    )),
                                          );
                                        },
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.edit_calendar_outlined,
                                          color: Colors.black,
                                          size: heightScreen * 0.06,
                                        )),
                                  ),
                                  SizedBox(
                                    height: sizeMargin,
                                  ),
                                  Text("Nueva reserva",
                                      style: TextStyle(fontSize: textSize)),
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
                            height: heightContainer,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.1,
                                    width: heightScreen * 0.1,
                                    child: FloatingActionButton(
                                        heroTag: 'btn3',
                                        onPressed: () async {
                                          var geolocation =
                                              widget.gym.geolocation;

                                          var latitude =
                                              geolocation.latitude.toString();
                                          var longitude =
                                              geolocation.longitude.toString();

                                          final intent = AndroidIntent(
                                              action: 'action_view',
                                              data: Uri.encodeFull(
                                                  'geo:$latitude,$longitude'),
                                              package:
                                                  'com.google.android.apps.maps');
                                          intent.launch();
                                        },
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.black,
                                          size: heightScreen * 0.06,
                                        )),
                                  ),
                                  SizedBox(
                                    height: sizeMargin,
                                  ),
                                  Text("Gimnasio",
                                      style: TextStyle(fontSize: textSize)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: heightContainer,
                            width: widthScreen / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: heightScreen * 0.1,
                                    width: heightScreen * 0.1,
                                    child: FloatingActionButton(
                                        heroTag: 'btn4',
                                        onPressed: () async {
                                          var instagram = widget.gym.instagram;
                                          final intent = AndroidIntent(
                                              action: 'action_view',
                                              data: Uri.encodeFull(
                                                  'http://instagram.com/$instagram'),
                                              package: 'com.instagram.android');
                                          intent.launch();
                                        },
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.public,
                                          color: Colors.black,
                                          size: heightScreen * 0.06,
                                        )),
                                  ),
                                  SizedBox(
                                    height: sizeMargin,
                                  ),
                                  Text("Instagram",
                                      style: TextStyle(fontSize: textSize)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: heightContainer * 0.9,
                            width: widthScreen,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Profile(
                                                      user: widget.user,
                                                    )),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: heightScreen * 0.1,
                                              height: heightScreen * 0.1,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                                shape: BoxShape.circle,
                                                image: DecorationImage( fit: BoxFit.cover, image: FileImage(File(widget.user.imageProfile!))),
                                            ),
                                            ),
                                            SizedBox(
                                              width: widthScreen * 0.08,
                                            ),
                                            Text(
                                                '${widget.user.name} ${widget.user.surname1}',
                                                style: TextStyle( color: Colors.black87, fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        widthScreen * 0.052)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
