import 'package:flutter/material.dart';
import 'package:gymapp/pages/pages.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

///Clase NewReserve
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
    var heightScreen = MediaQuery.of(context).size.height;
    state = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppSettings.mainColor(), size: widthScreen * 0.075),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:
            Text("Reservar cita", style: TextStyle(color: AppSettings.mainColor(), fontSize: widthScreen * 0.06)),
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
                    SizedBox(
                      height: heightScreen * 0.01,
                    ),
                    for (Activity activity in activities)
                      _activityCard(context, widthScreen, heightScreen, activity),
                    SizedBox(
                      height: heightScreen * 0.01,                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppSettings.loginColor()),
                  ));
              }
            } catch (e) {
              return Row();
            }
          }),
    );
  }

  ///Metodo que devuelve la card con la informacion de la actividad que le pasamos
  Column _activityCard(
      BuildContext context, double widthScreen, double heightScreen, Activity activity) {
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
              height: heightScreen * 0.21,
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
                      style: TextStyle(
                        fontSize: widthScreen * 0.08,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                            color: Colors.black87,
                            offset: Offset(2, 2),
                            blurRadius: 5,
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
