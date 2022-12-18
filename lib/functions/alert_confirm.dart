import 'package:flutter/material.dart';

Future<bool> alertConfirm(BuildContext context,
    {required String title, required String message}) async {
  bool reply = false;
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
              child: const Text("Yes")),
          TextButton(
              onPressed: () {
                reply = false;
                Navigator.pop(context);
              },
              child: const Text("No")),
        ],
      );
    },
  );
  return reply;
}
