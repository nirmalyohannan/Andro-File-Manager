import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder.dart';

import 'package:flutter/material.dart';
import '../widgets/file_type_Icon.dart';

class FileExplorerScreen extends StatelessWidget {
  String location;
  FileExplorerScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItems = dirListItems(location: location);
    final String directoryTitle;
    // isSelectionModeActive.value =
    //     false; //Will be set to false when a new page builds.
    selectedItems.value
        .clear(); //selected items Will be cleared when a new page builds.

    if (location == internalRootDir) {
      directoryTitle = 'Internal Storage';
    } else if (location == externalRootDir) {
      directoryTitle = 'SD Card';
    } else {
      directoryTitle = location.split('/').last;
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(directoryTitle),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: primaryColor,
            builder: (context, mainColor, child) => Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Text(location),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: selectedItems,
              builder: (context, selectedItems, child) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: dirItems.length,
                      itemBuilder: ((context, index) {
                        Icon icon =
                            fileTypeIcon(location: dirItems[index].path);
                        Color folderColor = Color.fromARGB(255, 230, 230, 230);
                        if (selectedItems.contains(dirItems[index])) {
                          print('::::::selected items contains true:::::::');
                          folderColor = primaryColor.value;
                        }

                        return fileFolderCard(context,
                            fileSystemEntity: dirItems[index],
                            icon: icon,
                            folderColor: folderColor);
                      })),
                );
              }),
        ],
      ),
    ));
  }
}
