import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/options/properties_options.dart';
import 'package:androfilemanager/widgets/options/rename_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void fileFolderOptions(BuildContext context,
    {required FileSystemEntity fileSystemEntity}) {
  ///::::::::Normal Options Declared into a variable::::::::::::
  List<Widget> normalOptions = [
    option(context, 'Rename', onPressed: () {
      renameOptions(context, fileSystemEntity: fileSystemEntity);
    }),
    option(context, 'Copy', onPressed: () {
      context.read<ToMoveItems>().clear();

      // toMoveItems.value.clear();
      context.read<ToCopyItems>().clear();
      // toCopyItems.value.clear();
      context.read<ToCopyItems>().add(fileSystemEntity);
      // toCopyItems.value.add(fileSystemEntity);
      // toCopyItems.notifyListeners();
      Navigator.pop(context);
    }),
    option(context, 'Move', onPressed: () {
      context.read<ToCopyItems>().clear();
      // toCopyItems.value.clear();
      context.read<ToMoveItems>().clear();

      // toMoveItems.value.clear();
      context.read<ToMoveItems>().add(fileSystemEntity);

      // toMoveItems.value.add(fileSystemEntity);
      // toMoveItems.notifyListeners();
      Navigator.pop(context);
    }),
    option(context, 'Delete', onPressed: () async {
      await deleteOperation(context, deleteItems: [fileSystemEntity]);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return FileExplorerScreen(location: fileSystemEntity.parent.path);
        },
      ));
    }),
    option(context, 'HideFile', onPressed: () {
      hideOperation(
          toHideFiles: [fileSystemEntity]); //todo: Working on Hide Files
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return FileExplorerScreen(location: fileSystemEntity.parent.path);
        }),
      );
    }),
    option(context, 'Properties', onPressed: () {
      propertiesOptions(context, path: fileSystemEntity.path);
    }),
  ];

  List<Widget> protectedOptions = [
    option(context, 'UnHide', onPressed: () {
      unHideOperation(toUnHideFiles: [fileSystemEntity]);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return FileExplorerScreen(location: fileSystemEntity.parent.path);
        },
      ));
    }),
    option(context, 'Copy', onPressed: () {
      context.read<ToMoveItems>().clear();

      // toMoveItems.value.clear();
      context.read<ToCopyItems>().clear();
      // toCopyItems.value.clear();
      context.read<ToCopyItems>().add(fileSystemEntity);
      // toCopyItems.value.add(fileSystemEntity);
      // toCopyItems.notifyListeners();
      Navigator.pop(context);
    }),
    option(context, 'Move', onPressed: () {
      context.read<ToCopyItems>().clear();

      // toCopyItems.value.clear();
      context.read<ToMoveItems>().clear();

      // toMoveItems.value.clear();
      context.read<ToMoveItems>().add(fileSystemEntity);

      // toMoveItems.value.add(fileSystemEntity);
      // toMoveItems.notifyListeners();
      Navigator.pop(context);
    }),
    option(context, 'Delete', onPressed: () async {
      await deleteOperation(context, deleteItems: [fileSystemEntity]);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return FileExplorerScreen(location: fileSystemEntity.parent.path);
        },
      ));
    }),
    option(context, 'Properties', onPressed: () {
      propertiesOptions(context, path: fileSystemEntity.path);
    }),
  ];
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: fileSystemEntity.path.contains(protectedDir.path)
                ? protectedOptions
                : normalOptions,
          ),
        );
      });
}

Widget option(BuildContext context, String title,
    {required Function onPressed}) {
  return InkWell(
    splashColor: context.read<ColorThemes>().primaryColor,
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
