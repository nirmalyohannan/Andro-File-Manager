import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../pages/file_explorer_screen.dart';

openDir(BuildContext context, {required String location}) {
  if (FileSystemEntity.isFileSync(location)) {
    log("You Clicked on a File"); //
    OpenFile.open(location);
  } else {
    log("You Clicked on a Folder:::::$location"); //
    if (locationValidation(location, context)) {
      bool hideLocation = false;
      if (protectedDir.path == location) {
        hideLocation = true;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileExplorerScreen(
            location: location,
            hideLocation: hideLocation,
          ),
        ),
      );
    }
  }
}

bool locationValidation(String location, BuildContext context) {
  if (location == '${internalRootDir}Android/data' ||
      location == '${internalRootDir}Android/obb') {
    log("You are trying to access android"); //
    const snackBar = SnackBar(
      //snackbar for no permission
      content: Text('No permission !!'),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar); //scaffold messenger for no permission
    return false;
  } else {
    //authorisation given to access the folder
    return true;
  }
}
