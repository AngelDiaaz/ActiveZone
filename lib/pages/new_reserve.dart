import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/appstate.dart';

class NewReserve extends StatefulWidget {
  const NewReserve({Key? key}) : super(key: key);

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
        title: const Text("Reservar cita",style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            List notes = snapshot.data ?? [];
            // return ListView(
            //   children: [
            //     for (Note note in notes) _noteCard(context, note),
            //   ],
            // );
            return Column(children: [
              const SizedBox(height: 10,),
              Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: SizedBox(
                      width: widthScreen,
                      height: 180,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/spinning.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const ListTile(
                            title: Text(
                              'Spinning',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))),
              Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 1,
                  margin:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: SizedBox(
                      width: widthScreen,
                      height: 180,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/pilates.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const ListTile(
                            title: Text(
                              'Pilates',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))),
              Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 1,
                  margin:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  child: SizedBox(
                      width: widthScreen,
                      height: 180,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/zumba.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          child: const ListTile(
                            title: Text(
                              'Zumba',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))),
            ]);
          }),
    );
  }
}