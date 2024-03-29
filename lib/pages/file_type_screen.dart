
import 'dart:io';
import 'package:androfilemanager/functions/native_call_media.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';
import 'package:flutter/material.dart';
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
          title: Text(directoryTitle),
          elevation: 0,
          actions: [
            selectedItemsOptions(),
          ],
        ),
        body: SafeArea(
          child: Column(
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
                                      return fileFolderCard(
                                        context,
                                        fileSystemEntity: File(pathList[index]),
                                        icon: icon,
                                        // folderColor: folderColor,
                                      );
                                    });
                              })),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
