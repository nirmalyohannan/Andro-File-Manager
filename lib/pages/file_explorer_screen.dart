import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/options/move_button.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';

import 'package:flutter/material.dart';

class FileExplorerScreen extends StatelessWidget {
  final String location;
  final bool hideLocation;
  const FileExplorerScreen(
      {super.key, required this.location, this.hideLocation = false});

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItemsList = dirListItems(location: location);
    final String directoryTitle;

    // isSelectionModeActive.value =
    //     false; //Will be set to false when a new page builds.
    selectedItems.value
        .clear(); //selected items Will be cleared when a new page builds.

    if (location == internalRootDir || "$location/" == internalRootDir) {
      directoryTitle = 'Internal Storage';
    } else if (location == externalRootDir || "$location/" == externalRootDir) {
      directoryTitle = 'SD Card';
    } else {
      directoryTitle = location.split('/').last;
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(directoryTitle),
        elevation: 0,
        actions: [
          moveButton(path: location),
          selectedItemsOptions(),
        ],
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
              child: Text(hideLocation ? '' : location),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: selectedItems,
              builder: (context, selectedItems, child) {
                return Expanded(
                  child: dirItemsList.isEmpty
                      ? const Center(
                          child: Text(
                            "Folder is Empty",
                            style: TextStyle(fontSize: 24),
                          ),
                        )
                      : ListView.builder(
                          itemCount: dirItemsList.length,
                          itemBuilder: ((context, index) {
                            Color folderColor =
                                const Color.fromARGB(255, 230, 230, 230);
                            if (selectedItems.contains(dirItemsList[index])) {
                              print(
                                  '::::::selected items contains true:::::::');
                              folderColor = primaryColor.value;
                            }

                            return FutureBuilder(
                                future: fileTypeThumbnail(
                                    location: dirItemsList[index].path),
                                builder: (context, iconSnapshot) {
                                  Widget icon;
                                  if (iconSnapshot.connectionState !=
                                      ConnectionState.done) {
                                    icon = fileTypeIcon(
                                        location: dirItemsList[index].path);
                                  } else {
                                    icon = iconSnapshot.data!;
                                  }
                                  return fileFolderCard(context,
                                      fileSystemEntity: dirItemsList[index],
                                      icon: icon,
                                      folderColor: folderColor);
                                });
                          })),
                );
              }),
        ],
      ),
    ));
  }
}
