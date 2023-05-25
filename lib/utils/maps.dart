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

  // static Intent newInstagramProfileIntent(PackageManager pm, String url) {
  //   final Intent intent = new Intent(Intent.ACTION_VIEW);
  //   try {
  //     if (pm.getPackageInfo("com.instagram.android", 0) != null) {
  //       if (url.endsWith("/")) {
  //         url = url.substring(0, url.length() - 1);
  //       }
  //       final String username = url.substring(url.lastIndexOf("/") + 1);
  //       // http://stackoverflow.com/questions/21505941/intent-to-open-instagram-user-profile-on-android
  //       intent.setData(Uri.parse("http://instagram.com/_u/" + username));
  //       intent.setPackage("com.instagram.android");
  //       return intent;
  //     }
  //   } catch (NameNotFoundException ignored) {
  //   }
  //   intent.setData(Uri.parse(url));
  //   return intent;
  // }
}
