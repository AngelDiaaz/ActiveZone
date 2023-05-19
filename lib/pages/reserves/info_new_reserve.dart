import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/services/services.dart';
import '../../models/models.dart';
import 'package:gymapp/pages/pages.dart';

/// Clase InfoNewReserve
class InfoNewReserve extends StatefulWidget {
  final String activityName;
  final User user;

  const InfoNewReserve(
      {Key? key, required this.activityName, required this.user})
      : super(key: key);

  @override
  State<InfoNewReserve> createState() => _InfoNewReserveState();
}

class _InfoNewReserveState extends State<InfoNewReserve> {
  double width = 0;
  int index = 0;
  Schedule schedule =
      Schedule(id: '', hour: '', numberUsers: 0, date: Timestamp(0, 0));
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
                child: FutureBuilder(
                  future: state.getImageActivity(widget.activityName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data!));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ]),
            Row(
              children: [
                SizedBox(
                  height: heightScreen * 4 / 6,
                  width: widthScreen,
                  child:
                      InfoHours(activityName: widget.activityName, user: widget.user),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
