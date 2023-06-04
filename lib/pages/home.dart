import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:gymapp/pages/reserves/my_reserves.dart';
import 'package:gymapp/services/services.dart';
import 'package:gymapp/utils/page_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Clase HomePage
class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState? state;
  Gym? gym;
  Color buttonColor = const Color.fromRGBO(20, 44, 68, 1);

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
        child: FutureBuilder(
            future: state!.getGym(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                gym = snapshot.data!;
                return Column(
                  children: [
                    Stack(children: [
                      SizedBox(
                          height: heightScreen * 0.35,
                          width: widthScreen,
                          child: gym!.image!.isEmpty
                              ? Image.asset(
                                  'assets/images/gym.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(gym!.image!)),
                      Positioned(
                        top: heightScreen * 0.06,
                        right: widthScreen * 0.05,
                        child: IconButton(
                          icon: Icon(
                            Icons.logout,
                            size: heightScreen * 0.05,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showAlertDialog(context);
                          },
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        SizedBox(
                          height: heightScreen * 0.65,
                          width: widthScreen,
                          child: Column(
                            children: [
                              SizedBox(
                                height: heightScreen * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: heightContainer,
                                    width: widthScreen / 2,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: heightScreen * 0.1,
                                            width: heightScreen * 0.1,
                                            child: FloatingActionButton(
                                                elevation: 20,
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
                                                  color: buttonColor,
                                                  size: heightScreen * 0.06,
                                                )),
                                          ),
                                          SizedBox(
                                            height: sizeMargin,
                                          ),
                                          Text("Mis reservas",
                                              style: TextStyle(
                                                  fontSize: textSize, color: buttonColor)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: heightScreen * 0.1,
                                            width: heightScreen * 0.1,
                                            child: FloatingActionButton(
                                                elevation: 20,
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
                                                  color: buttonColor,
                                                  size: heightScreen * 0.06,
                                                )),
                                          ),
                                          SizedBox(
                                            height: sizeMargin,
                                          ),
                                          Text("Nueva reserva",
                                              style: TextStyle(
                                                  fontSize: textSize, color: buttonColor)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: heightScreen * 0.1,
                                            width: heightScreen * 0.1,
                                            child: FloatingActionButton(
                                                elevation: 20,
                                                heroTag: 'btn3',
                                                onPressed: () async {
                                                  var geolocation =
                                                      gym!.geolocation;

                                                  var latitude = geolocation
                                                      .latitude
                                                      .toString();
                                                  var longitude = geolocation
                                                      .longitude
                                                      .toString();

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
                                                  color: buttonColor,
                                                  size: heightScreen * 0.06,
                                                )),
                                          ),
                                          SizedBox(
                                            height: sizeMargin,
                                          ),
                                          Text("Gimnasio",
                                              style: TextStyle(
                                                  fontSize: textSize, color: buttonColor)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: heightScreen * 0.1,
                                            width: heightScreen * 0.1,
                                            child: FloatingActionButton(
                                                elevation: 20,
                                                heroTag: 'btn4',
                                                onPressed: () async {
                                                  var instagram =
                                                      gym!.instagram;
                                                  final intent = AndroidIntent(
                                                      action: 'action_view',
                                                      data: Uri.encodeFull(
                                                          'http://instagram.com/$instagram'),
                                                      package:
                                                          'com.instagram.android');
                                                  intent.launch();
                                                },
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.public,
                                                  color: buttonColor,
                                                  size: heightScreen * 0.06,
                                                )),
                                          ),
                                          SizedBox(
                                            height: sizeMargin,
                                          ),
                                          Text("Instagram",
                                              style: TextStyle(
                                                  fontSize: textSize, color: buttonColor)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                      height:
                                                          heightScreen * 0.1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 2.0,
                                                        ),
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: widget
                                                                  .user
                                                                  .imageProfile!
                                                                  .isEmpty
                                                              ? const NetworkImage(
                                                                  'https://firebasestorage.googleapis.com/v0/b/gymapp-8a4d2.appspot.com/o/image%2Factivity%2Fprofile.jpg?alt=media&token=c0d74362-e1bb-420d-9772-9681c73d5a76&_gl=1*10cz45j*_ga*MTcxNDQxNTU0LjE2NzQ1NTk2OTU.*_ga_CW55HF8NVT*MTY4NTcyMTc4NS44Ny4xLjE2ODU3MjE5NDkuMC4wLjA.')
                                                              : NetworkImage(widget
                                                                  .user
                                                                  .imageProfile!),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: widthScreen * 0.08,
                                                    ),
                                                    Text(
                                                        '${widget.user.name} ${widget.user.surname1}',
                                                        style: TextStyle(
                                                            color: buttonColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                widthScreen *
                                                                    0.052)),
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
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppSettings.loginColor()),
                  ),
                );
              }
            }),
      ),
    );
  }

  ///Metodo que muestra una alert para confirmar si quieres cerrar sesion
  showAlertDialog(BuildContext context) {
    Widget cancelButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text("No", style: TextStyle(color: AppSettings.loginColor())),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        "Sí",
        style: TextStyle(color: AppSettings.loginColor()),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', false);

        if (!mounted) return;
        Navigator.pushNamed(context, 'login');
      },
    );
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: const Text("¿Quieres cerrar sesión?"),
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
