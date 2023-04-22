import 'package:flutter/material.dart';
import '../../models/models.dart';

class ChooseHour extends StatefulWidget {
  final Activity activity;

  const ChooseHour({Key? key, required this.activity}) : super(key: key);

  @override
  State<ChooseHour> createState() => _ChooseHourState();
}

class _ChooseHourState extends State<ChooseHour> {
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    var schedules = widget.activity.schedule!;
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
                  child: Row(
                    //TODO arreglar posicionamiento de los botones
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (Schedule schedule in schedules)
                          if (schedules.length >= 3) rowA(schedule),
                      ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row rowA(Schedule schedule) {
    return Row(
      children: [
        Container(
          color: Colors.red,
          child: hourButton(schedule),
        ),
      ],
    );
  }

  Container hourButton(Schedule schedule) {
    return Container(
      width: 110,
      height: 60,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black26, // your color here
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(2)))),
        child: Text(
          schedule.hour,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
