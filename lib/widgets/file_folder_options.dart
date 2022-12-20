import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/options/properties_options.dart';
import 'package:androfilemanager/widgets/options/rename_options.dart';
import 'package:flutter/material.dart';

void fileFolderOptions(BuildContext context,
    {required FileSystemEntity fileSystemEntity}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option('Rename', onPressed: () {
                renameOptions(context, fileSystemEntity: fileSystemEntity);
              }),
              option('Copy', onPressed: () {}),
              option('Move', onPressed: () {
                toMoveItems.value.clear();
                toMoveItems.value.add(fileSystemEntity);
                toMoveItems.notifyListeners();
                Navigator.pop(context);
              }),
              option('Delete', onPressed: () async {
                await deleteOperation(context, deleteItems: [fileSystemEntity]);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return FileExplorerScreen(
                        location: fileSystemEntity.parent.path);
                  },
                ));
              }),
              option('HideFile', onPressed: () {}),
              option('Properties', onPressed: () {
                propertiesOptions(context, path: fileSystemEntity.path);
              }),
            ],
          ),
        );
      });
}

Widget option(String title, {required Function onPressed}) {
  return InkWell(
    splashColor: primaryColor.value,
    onTap: () {
      onPressed();
    },
    child: Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
