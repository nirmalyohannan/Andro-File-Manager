import 'dart:developer';
import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/recent_files_database/recent_file_model.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentFilesScreen extends StatefulWidget {
  const RecentFilesScreen({
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
    context.read<SelectedItems>().items.clear();
//selected items Will be cleared when a new page builds.

    return WillPopScope(
      onWillPop: () async {
        //willpopScope interrupts the back button
        //returns true (allows go back) if files are selected;
        //blocks go back and empties selected items if contains any
        if (context.read<SelectedItems>().items.isEmpty) {
          return true;
        } else {
          context.read<SelectedItems>().clear();
          return false;
        }
      },
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
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Consumer<ColorThemes>(
                builder: (context, colorThemes, child) => Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 10),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: colorThemes.primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                ),
              ),
              Expanded(
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
                          return FutureBuilder(
                              future:
                                  fileTypeThumbnail(dirItemsList[index].path),
                              builder: (context, iconSnapshot) {
                                Widget icon;
                                if (iconSnapshot.connectionState !=
                                    ConnectionState.done) {
                                  icon = fileTypeIcon(
                                      location: dirItemsList[index].path);
                                } else {
                                  icon = iconSnapshot.data!;
                                }
                                return fileFolderCard(
                                  context,
                                  fileSystemEntity: dirItemsList[index],
                                  icon: icon,
                                  // folderColor: folderColor,
                                );
                              });
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
