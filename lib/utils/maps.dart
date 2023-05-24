import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Maps{

  static Future<void> openGoogleMaps(String latitude, String longitude) async {
    String mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
    await launchUrl(Uri.parse(mapsUrl));
    } else {
    throw 'No se pudo abrir la aplicación de Google Maps.';
    }
  }
}
