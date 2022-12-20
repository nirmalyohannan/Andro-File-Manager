import 'package:flutter/material.dart';

Future<bool> alertConfirm(BuildContext context,
    {required String title, required String message}) async {
  bool reply = false;
  TextStyle textStyle = const TextStyle(color: Colors.blue);
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                reply = true;
                Navigator.pop(context);
              },
              child: Text(
                "Yes",
                style: textStyle,
              )),
          TextButton(
              onPressed: () {
                reply = false;
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: textStyle,
              )),
        ],
      );
    },
  );
  return reply;
}
