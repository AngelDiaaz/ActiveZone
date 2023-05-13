import 'package:flutter/material.dart';
import 'package:gymapp/services/appstate.dart';
import '../../models/models.dart';
import 'info_hours.dart';

/// Clase InfoNewReserve
class InfoNewReserve extends StatefulWidget {
  final Activity activity;
  final User? user;

  const InfoNewReserve({Key? key, required this.activity, this.user})
      : super(key: key);

  @override
  State<InfoNewReserve> createState() => _InfoNewReserveState();
}

class _InfoNewReserveState extends State<InfoNewReserve> {
  double width = 0;
  int index = 0;
  Schedule schedule = Schedule(id: '',hour: '', numberUsers: 0, date: '');
  AppState state = AppState();
  List<Schedule> a = [];

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: widthScreen,
        height: heightScreen,
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                height: heightScreen * 2 / 6,
                width: widthScreen,
                child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.activity.image)),
              ),
            ]),
            Row(
              children: [
                SizedBox(
                  height: heightScreen * 4 / 6,
                  width: widthScreen,
                  //TODO arreglar nombre de la actividad
                  child: InfoHours(
                      activity: widget.activity,
                      user: widget.user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
