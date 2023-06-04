import 'package:flutter/material.dart';
import 'package:gymapp/services/services.dart';
import '../../models/models.dart';
import 'package:gymapp/pages/pages.dart';
import '../../utils/utils.dart';

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
  AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
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
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppSettings.loginColor())));
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
