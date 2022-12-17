import 'dart:io';

import 'package:androfilemanager/functions/dir_size_calc.dart';
import 'package:flutter/material.dart';

void selectedPropertiesOptions(BuildContext context,
    {required List<FileSystemEntity> selectedItems}) {
  showDialog(
    context: context,
    builder: (context) {
      // final stat = FileStat.statSync(path);
      // String dateModified = stat.modified.toString().split(".").first;

      TextStyle fieldNameTextStyle =
          const TextStyle(fontWeight: FontWeight.w800);
      // String fileName = path.split('/').last.toString();
      // String fileType;
      // if (FileSystemEntity.isDirectorySync(path)) {
      //   fileType = "Folder";
      // } else if (fileName.contains(".")) {
      //   fileType = fileName.split(".").last;
      // } else {
      //   fileType = "File";
      // }
      int size = 0;
      for (var element in selectedItems) {
        size = size + directorySizeCalc(element.path);
      }
      String sizeMB = (size / (1024 * 1024)).toStringAsFixed(2);
      return AlertDialog(
        title: const Text(
          "Properties",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //::::::Selected Count::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected: ",
                  style: fieldNameTextStyle,
                ),
                Expanded(
                  child: Text(
                    "${selectedItems.length} items",
                  ),
                )
              ],
            ),

            //::::::SIZE::::::
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Size: ",
                  style: fieldNameTextStyle,
                ),
                Text('${sizeMB.toString()} MB')
              ],
            ),
          ],
        ),
      );
    },
  );
}
