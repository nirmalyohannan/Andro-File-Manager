import 'package:flutter/material.dart';

void androSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: (Text(message))));
}
