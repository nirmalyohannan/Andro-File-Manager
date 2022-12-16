import 'dart:io';

import 'package:androfilemanager/functions/dir_size_calc.dart';
import 'package:flutter/material.dart';

void propertiesOptions(BuildContext context, {required String path}) {
  showDialog(
    context: context,
    builder: (context) {
      final stat = FileStat.statSync(path);
      String dateModified = stat.modified.toString().split(".").first;

      TextStyle fieldNameTextStyle =
          const TextStyle(fontWeight: FontWeight.w800);
      String fileName = path.split('/').last.toString();
      String fileType;
      if (FileSystemEntity.isDirectorySync(path)) {
        fileType = "Folder";
      } else if (fileName.contains(".")) {
        fileType = fileName.split(".").last;
      } else {
        fileType = "File";
      }
      return AlertDialog(
        title: const Text(
          "Properties",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //::::::Name::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ",
                  style: fieldNameTextStyle,
                ),
                Expanded(
                  child: Text(
                    fileName,
                  ),
                )
              ],
            ),
            //::::::File Type::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Type: ",
                  style: fieldNameTextStyle,
                ),
                Text(
                  fileType,
                )
              ],
            ),
            //::::::SIZE::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Size: ",
                  style: fieldNameTextStyle,
                ),
                Text(readableDirSizeCalc(path))
              ],
            ),
            //::::::MODIFIED TIME::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Modified: ",
                  style: fieldNameTextStyle,
                ),
                Text(dateModified)
              ],
            ),
            //::::::PATH::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Path: ",
                  style: fieldNameTextStyle,
                ),
                Expanded(
                  child: Text(
                    path,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}
