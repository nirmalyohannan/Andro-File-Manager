import 'dart:developer';

import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/native_call_media.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FileTypeScreen extends StatelessWidget {
  final String directoryTitle;
  final MediaType mediaType;
  const FileTypeScreen(
      {super.key, required this.directoryTitle, required this.mediaType});

  @override
  Widget build(BuildContext context) {
    // List<FileSystemEntity> dirItemsList =
    //     scanFileType(widget.typesList, internalRootDir);

    context.read<SelectedItems>().items.clear();
    //selected items Will be cleared when a new page builds.

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(directoryTitle),
        elevation: 0,
        actions: [
          selectedItemsOptions(),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Consumer<ColorThemes>(
            builder: (context, colorThemes, child) => Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: colorThemes.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
            ),
          ),
          FutureBuilder(
              // future: compute(getGalleryImages, ''),
              future: getMedias(mediaType),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<String> pathList = snapshot.data!;

                return Consumer<SelectedItems>(
                    builder: (context, selectedItems, child) {
                  return Expanded(
                    child: pathList.isEmpty
                        ? const Center(
                            child: Text(
                              "Folder is Empty",
                              style: TextStyle(fontSize: 24),
                            ),
                          )
                        : ListView.builder(
                            itemCount: pathList.length,
                            itemBuilder: ((context, index) {
                              Color folderColor =
                                  const Color.fromARGB(255, 230, 230, 230);
                              if (selectedItems.items
                                  .contains(File(pathList[index]))) {
                                log('::::::selected items contains true:::::::');
                                folderColor =
                                    context.watch<ColorThemes>().primaryColor;
                              }

                              return FutureBuilder(
                                  future: fileTypeThumbnail(pathList[index]),
                                  builder: (context, iconSnapshot) {
                                    Widget icon;
                                    if (!iconSnapshot.hasData) {
                                      icon = fileTypeIcon(
                                          location: pathList[index]);
                                    } else {
                                      icon = iconSnapshot.data!;
                                    }
                                    return fileFolderCard(context,
                                        fileSystemEntity: File(pathList[index]),
                                        icon: icon,
                                        folderColor: folderColor);
                                  });
                            })),
                  );
                });
              }),
        ],
      ),
    ));
  }
}
