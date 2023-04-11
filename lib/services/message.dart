import 'package:flutter_sms/flutter_sms.dart';

// TODO mirar lo de los sms y lo de enviar emails

class SendMessage {
  Future<void> sending_SMS(String msg, List<String> list_receipents) async {
    String send_result = await sendSMS(message: msg, recipients: list_receipents)
        .catchError((err) {
      print(err);
    });
    print(send_result);
  }
}