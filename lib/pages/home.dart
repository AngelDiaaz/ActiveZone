import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: heightScreen,
        width: widthScreen,
        color: Colors.green,
        child: Column(
          children: [
            Row(children: [
              Container(
                  color: Colors.red,
                  height: heightScreen * 2 / 5,
                  width: widthScreen,
                  //TODO mirar tamaño de la foto
                  child: Image.asset('assets/images/gym1.jpg')),
            ]),
            Row(
              children: [
                Container(
                  color: Colors.blue,
                  height: heightScreen * 3 / 5,
                  width: widthScreen,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
