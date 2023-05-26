import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class NewReserve extends StatefulWidget {
  final User user;

  const NewReserve({Key? key, required this.user}) : super(key: key);

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
          future: state!.getActivities(false),
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> snapshot) {
            try {
              if (snapshot.hasData) {
                List<Activity> activities = snapshot.data!;
                return ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    for (Activity activity in activities)
                      _activityCard(context, widthScreen, activity),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            } catch (e) {
              return Row();
            }
          }),
    );
  }

  ///Metodo que devuelve la card con la informacion de la actividad que le pasamos
  Column _activityCard(
      BuildContext context, double widthScreen, Activity activity) {
    return Column(children: [
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
                                activityName: activity.name,
                                user: widget.user,
                              )),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      activity.name,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )))
    ]);
  }
}
