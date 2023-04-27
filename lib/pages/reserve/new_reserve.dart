import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class NewReserve extends StatefulWidget {
  final Gym gym;

  const NewReserve({Key? key, required this.gym}) : super(key: key);

  @override
  State<NewReserve> createState() => _NewReserveState();
}

class _NewReserveState extends State<NewReserve> {
  AppState? state;

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    state = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Reservar cita", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            // Gym gym = snapshot.data ?? [];
            return ListView(
              children: [
                for (Activity activity in widget.gym.activities)
                  _activityCard(context, widthScreen, activity),
              ],
            );
          }),
    );
  }

  Column _activityCard(
      BuildContext context, double widthScreen, Activity activity) {
    return Column(children: [
      const SizedBox(
        height: 10,
      ),
      Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: SizedBox(
              width: widthScreen,
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(activity.image)),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoNewReserve(
                            activity: activity,
                          )),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      activity.name,
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))),
    ]);
  }
}
