import 'package:flutter/material.dart';

import '../constants.dart';

class Alert {
  static alertAuth(context, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error', style: TextStyle(color: kPrimaryColor)),
          backgroundColor: kSecundaryColor,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: const TextStyle(color: kPrimaryColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
