import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/recent_files_database/recent_file_model.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/options/copy_button.dart';
import 'package:androfilemanager/widgets/options/move_button.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';

import 'package:flutter/material.dart';

class RecentFilesScreen extends StatefulWidget {
  RecentFilesScreen({
    super.key,
  });

  @override
  State<RecentFilesScreen> createState() => _RecentFilesScreenState();
}

class _RecentFilesScreenState extends State<RecentFilesScreen> {
  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItemsList = [];
    for (RecentFile element in appRecentFiles.values) {
      String parentPath = Directory(element.path).parent.path;
      for (FileSystemEntity file in Directory(parentPath).listSync()) {
        if (file.path == element.path) {
          dirItemsList.add(file);
        }
      }
    }
    dirItemsList = dirItemsList.reversed.toList();

    // isSelectionModeActive.value =
    //     false; //Will be set to false when a new page builds.
    selectedItems.value
        .clear(); //selected items Will be cleared when a new page builds.

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Recent Files"),
        elevation: 0,
        actions: [
          selectedItemsOptions(),
          InkWell(
            onTap: () async {
              await appRecentFiles.clear();
              Navigator.pushReplacement(context, routeRecentFiles());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: const [Icon(Icons.cancel), Text("Clear")],
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: primaryColor,
            builder: (context, mainColor, child) => Container(
              padding: const EdgeInsets.only(right: 20, bottom: 10),
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
                            "No Recent Files",
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
