import 'package:flutter/material.dart';
import '../../models/models.dart';

class ConfirmReserve extends StatefulWidget {
  final List<User> users;

  const ConfirmReserve({Key? key, required this.users}) : super(key: key);

  @override
  State<ConfirmReserve> createState() => _ConfirmReserveState();
}

class _ConfirmReserveState extends State<ConfirmReserve> {
  double width = 0;

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    width = widthScreen;
    var heightScreen = MediaQuery.of(context).size.height;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: heightScreen * 4 / 6,
                width: widthScreen,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.red,
                            width: 200,
                            height: 200,
                          )
                        ],
                      ),
                      const Divider(
                          height: 10,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.black54),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
              ),
            ],
          )
        ]);
  }
}
