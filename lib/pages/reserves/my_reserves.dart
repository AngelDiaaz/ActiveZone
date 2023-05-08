import 'package:flutter/material.dart';

class MyReserves extends StatelessWidget {
  const MyReserves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            height: heightScreen,
            width: widthScreen,
            child: Column(children: [
              Row(children: [
                SizedBox(
                    height: heightScreen * 2 / 6,
                    width: widthScreen,
                    child: Image.asset(
                      'assets/images/gym1.jpg',
                      fit: BoxFit.cover,
                    )),
              ]),
              Row(children: [
                SizedBox(
                    height: heightScreen * 4 / 6,
                    width: widthScreen,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                color: Colors.red,
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                child: SizedBox(
                                    width: widthScreen - 12,
                                    height: 150,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 0, 0),
                                              child: Row(children: [
                                                Container(width: 100, height: 100, color: Colors.green,),
                                                const SizedBox(width: 20,),
                                                Column(
                                                  children: const [
                                                    Text(
                                                      'Nombre de la actividad',
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Fecha de la actividad',
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Hora de la actividad',
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ])),
                                        ],
                                      ),
                                      // child: TextButton(
                                      //   onPressed: () {},
                                      //   child: const ListTile(
                                      //     title: Text(
                                      //       'Nombre de la actividad',
                                      //       style: TextStyle(
                                      //           fontSize: 30,
                                      //           color: Colors.black,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //     subtitle: Text('Fecha de la actividad'),
                                      //   ),
                                      // ),
                                    ))),
                          ],
                        )
                      ],
                    ))
              ])
            ])));
  }
}
