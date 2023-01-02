//This Widget is a card in File explorer screens where File or Folder will be
//represented as a Card with File/Folder icon, Name, size, option button

import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/open_dir.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder_options.dart';
import 'package:flutter/material.dart';

Widget gridFileFolderCard(BuildContext context,
    {required FileSystemEntity fileSystemEntity,
    required Widget icon,
    required Color folderColor}) {
  //Color folderColor = Color.fromARGB(255, 230, 230, 230);
  // ValueNotifier<Color> folderColor =
  //     ValueNotifier(const Color.fromARGB(255, 230, 230, 230));

  String path = fileSystemEntity.path;
  // String folderSize = showFolderSize ? readableDirSizeCalc(path) : '';
  return InkWell(
      splashFactory: InkRipple.splashFactory,
      splashColor: primaryColor.value,
      onTap: () {
        if (selectedItems.value.isNotEmpty) {
          if (selectedItems.value.contains(fileSystemEntity) == false) {
            selectedItems.value.add(fileSystemEntity);
            selectedItems.notifyListeners();

            // print(selectedItems.value);
          } else {
            // print('unselect');
            selectedItems.value.remove(fileSystemEntity);
            selectedItems.notifyListeners();

            // print(selectedItems.value);
          }
        } else {
          openDir(context, location: path, fileSystemEntity: fileSystemEntity);
        }
      },
      onLongPress: () {
        if (selectedItems.value.contains(fileSystemEntity) == false) {
          selectedItems.value.add(fileSystemEntity);
          selectedItems.notifyListeners();

          // print(selectedItems.value);
        } else {
          // print('::::${selectedItems.value.remove(fileSystemEntity)}');
          selectedItems.notifyListeners();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: folderColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            icon,
            Text(path.split('/').last),
            Visibility(
              visible: selectedItems.value.isEmpty,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                iconSize: 30,
                onPressed: () {
                  fileFolderOptions(context,
                      fileSystemEntity: fileSystemEntity);
                },
              ),
            ),
          ],
        ),
      )
      // ;})
      );
}
