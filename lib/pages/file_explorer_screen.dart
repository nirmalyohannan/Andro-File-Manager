import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/functions/new_folder.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/options/copy_button.dart';
import 'package:androfilemanager/widgets/options/move_button.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';

import 'package:flutter/material.dart';

class FileExplorerScreen extends StatefulWidget {
  final String location;
  bool hideLocation;
  FileExplorerScreen(
      {super.key, required this.location, this.hideLocation = false});

  @override
  State<FileExplorerScreen> createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends State<FileExplorerScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    selectedItems.value.clear();
    super.dispose();
    Future.delayed(const Duration(milliseconds: 50))
        .then((value) => selectedItems.notifyListeners());
  }

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItemsList =
        dirListItems(location: widget.location);
    final String directoryTitle;

    // isSelectionModeActive.value =
    //     false; //Will be set to false when a new page builds.
    selectedItems.value
        .clear(); //selected items Will be cleared when a new page builds.

    if (widget.location == internalRootDir ||
        "${widget.location}/" == internalRootDir) {
      directoryTitle = 'Internal Storage';
    } else if (widget.location == externalRootDir ||
        "${widget.location}/" == externalRootDir) {
      directoryTitle = 'SD Card';
    } else if (widget.location.contains(protectedDir.path)) {
      widget.hideLocation = true;
      directoryTitle = "Protected Files";
    } else {
      directoryTitle = widget.location.split('/').last;
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(directoryTitle),
        elevation: 0,
        actions: [
          copyButton(path: widget.location),
          moveButton(path: widget.location),
          selectedItemsOptions(),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: primaryColor,
            builder: (context, mainColor, child) => Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(widget.hideLocation ? '' : widget.location)),
                  InkWell(
                    onTap: () {
                      createNewFolder(context, widget.location);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return FileExplorerScreen(location: widget.location);
                        },
                      ));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [Icon(Icons.add), Text("New Folder")],
                    ),
                  )
                ],
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
