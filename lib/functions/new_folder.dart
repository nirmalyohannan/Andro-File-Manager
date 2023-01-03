import 'dart:io';

import 'package:flutter/material.dart';

void createNewFolder(BuildContext context, String location) {
  if (location.endsWith("/")) {
    location = '${location}New Folder';
  } else {
    location = '$location/New Folder';
  }

  while (Directory(location).existsSync()) {
    location = '${location}_copy';
  }
  Directory(location).createSync();
  //::::::::::::::::::::::::
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text("New Folder Created"),
    duration: Duration(milliseconds: 800),
  ));
}
