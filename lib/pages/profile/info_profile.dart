import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import 'package:image_picker/image_picker.dart';


///Clase Login
class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AppState state = AppState();
  double widthScreen = 0;
  double heightScreen = 0;
  var isEditing = false;
  File? image;
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String newPhone = '';
  String newEmail = '';

  @override
  Widget build(BuildContext context) {
    state = Provider.of<AppState>(context, listen: true);
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    phoneController.text = widget.user.phone!;
    emailController.text = widget.user.email!;
    return Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
      width: widthScreen,
      height: heightScreen,
      child: Stack(children: [
        //Pongo la foto de fondo
        Positioned(
            height: heightScreen * 0.4,
            width: widthScreen,
            child: Image.asset(
              'assets/images/gym.jpg',
              fit: BoxFit.cover,
            )),
        Center(
          child: Container(
            width: widthScreen * 0.9,
            height: heightScreen * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(widthScreen*0.012, heightScreen*0.005, 0, 0),
                    child: SizedBox(
                      height: heightScreen * 0.08,
                      width: heightScreen * 0.08,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_outlined,
                            size: widthScreen * 0.1),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, heightScreen*0.005, widthScreen*0.012, 0),
                    child: SizedBox(
                      height: heightScreen * 0.08,
                      width: heightScreen * 0.08,
                      child: IconButton(
                        icon:
                            Icon(isEditing ? Icons.save_as : Icons.edit_outlined, size: widthScreen * 0.1),
                        onPressed: () {
                          //Refresco la pagina y cambio los valores de editar
                          setState(() {
                            if (isEditing) {
                              isEditing = false;
                              newEmail = emailController.text;
                              newPhone = phoneController.text;

                              showAlertDialog(context);
                            } else {
                              isEditing = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heightScreen * 0.02,
              ),
              //TODO hacer foto perfil
              InkWell(
                onTap: _takePhoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: image != null ? FileImage(image!) : null,
                  child: image == null ? const Icon(Icons.camera_alt) : null,
                ),
              ),
              // CircleAvatar(
              //   radius: heightScreen * 0.08, // Radio del círculo
              //   backgroundImage: NetworkImage(
              //       widget.user.imageProfile!), // Ruta de la imagen de perfil
              // ),
              SizedBox(
                height: heightScreen * 0.05,
              ),
              Text(widget.user.dni,
                  style: TextStyle(fontSize: heightScreen * 0.035)),
              SizedBox(
                height: heightScreen * 0.05,
              ),
              Text(
                  '${widget.user.name} ${widget.user.surname1} ${widget.user.surname2}',
                  style: TextStyle(fontSize: heightScreen * 0.03)),
              SizedBox(
                height: heightScreen * 0.05,
              ),
              changeText(
                  widget.user.phone!, heightScreen * 0.03, phoneController),
              SizedBox(
                height: heightScreen * 0.02,
              ),
              changeText(
                  widget.user.email!, heightScreen * 0.02, emailController),
              SizedBox(
                height: heightScreen * 0.05,
              ),
              FutureBuilder(
                future: state.getUserActivity(widget.user),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var next = nextReserves(snapshot.data!);
                    return Text('Reservas próximas: $next',
                        style: TextStyle(fontSize: heightScreen * 0.022, wordSpacing: widthScreen * 0.01));
                  } else {
                    return Row();
                  }
                },
              ),
              SizedBox(
                height: heightScreen * 0.03,
              ),
              FutureBuilder(
                future: state.getUserActivity(widget.user),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var end = endReserves(snapshot.data!);
                    return Text('Reservas finalizadas: $end',
                        style: TextStyle(fontSize: heightScreen * 0.022, wordSpacing: widthScreen * 0.01));
                  } else {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(
                height: heightScreen * 0.03,
              ),
              FutureBuilder(
                future: state.getUserActivity(widget.user),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var total = totalReserves(snapshot.data!);
                    return Text('Reservas totales: $total',
                        style: TextStyle(fontSize: heightScreen * 0.028, fontWeight: FontWeight.w500, wordSpacing: widthScreen * 0.01));
                  } else {
                    return Row();
                  }
                },
              ),
            ]),
          ),
        ),
      ]),
    )));
  }

  ///Metodo que obtiene el total de las reservas que tiene el usuario
  int totalReserves(List<Activity> activity){
    var total = 0;
    for(Activity a in activity){
      total += a.schedule!.length;
    }

    return total;
  }

  ///Metodo que obtiene las proximas reservas de un usuario
  int nextReserves(List<Activity> activity){
    var next = 0;
    //Recorro la lista de actividades
    for(Activity a in activity){
      //Recorro de cada actividad los horarios que hay registrados
      for (Schedule s in a.schedule!){
        //Si la fecha de este horario es despues que la de hoy
        if (s.date.toDate().isAfter(DateTime.now())){
          next++;
        }
      }
    }
    return next;
  }

  ///Metodo que obtiene las reservas finalizadas de un usuario
  int endReserves(List<Activity> activity){
      var end = 0;
      for(Activity a in activity){
        //Recorro de cada actividad los horarios que hay registrados
        for (Schedule s in a.schedule!){
          //Si la fecha de ese horario es antes de hoy
          if (s.date.toDate().isBefore(DateTime.now())){
            end++;
          }
        }
      }
    return end;
  }

  Future<void> _takePhoto() async {
    final imageCamera = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageCamera != null) {
      setState(() {
        image = File(imageCamera.path);
      });
    }
  }

  SizedBox changeText(
      String text, double fontSize, TextEditingController controller) {
    return SizedBox(
      height: heightScreen * 0.05,
      width: widthScreen * 0.75,
      child: Stack(alignment: Alignment.center, children: [
        Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
        if (isEditing) ...[
          Positioned.fill(
            child: Container(
              width: widthScreen,
              height: heightScreen,
              color: Colors.white,
              child: TextField(
                maxLines: 1,
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
                //Para que a la hora de pulsar el boton Enter se cambie ya los cambios
                onSubmitted: (value) {
                  newEmail = emailController.text;
                  newPhone = phoneController.text;

                  setState(() {
                    showAlertDialog(context);

                    isEditing = false;
                  });
                },
              ),
            ),
          ),
        ],
      ]),
    );
  }

  ///Metodo que muestra una alert para confirmar si quieres eliminar la reserva o no
  showAlertDialog(BuildContext context) {
    Widget cancelButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text("No", style: TextStyle(color: LoginSettings.loginColor())),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        "Sí",
        style: TextStyle(color: LoginSettings.loginColor()),
      ),
      onPressed: () async {
        widget.user.email = newEmail;
        widget.user.phone = newPhone;

        await state.updateUser(widget.user.dni, widget.user);

        if (!mounted) return;
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: const Text("¿Quieres guardar los cambios?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}