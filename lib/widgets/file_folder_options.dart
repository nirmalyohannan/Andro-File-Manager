import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';

void fileFolderOptions(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option('Rename', onPressed: () {}),
              option('Copy', onPressed: () {}),
              option('Move', onPressed: () {}),
              option('Delete', onPressed: () {}),
              option('HideFile', onPressed: () {}),
              option('Properties', onPressed: () {}),
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
