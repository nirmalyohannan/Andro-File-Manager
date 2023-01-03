import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/functions/scan_file_type.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/options/copy_button.dart';
import 'package:androfilemanager/widgets/options/move_button.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';

import 'package:flutter/material.dart';

class FileTypeScreen extends StatefulWidget {
  final String directoryTitle;
  final List<String> typesList;
  const FileTypeScreen(
      {super.key, required this.directoryTitle, required this.typesList});

  @override
  State<FileTypeScreen> createState() => _FileTypeScreenState();
}

class _FileTypeScreenState extends State<FileTypeScreen> {
  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItemsList =
        scanFileType(typesList: widget.typesList, location: internalRootDir);

    selectedItems.value
        .clear(); //selected items Will be cleared when a new page builds.

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.directoryTitle),
        elevation: 0,
        actions: [
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
