import 'dart:io';
import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_list_items.dart';
import 'package:androfilemanager/functions/new_folder.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/file_folder.dart';
import 'package:androfilemanager/widgets/file_type_icon.dart';
import 'package:androfilemanager/widgets/options/copy_button.dart';
import 'package:androfilemanager/widgets/options/move_button.dart';
import 'package:androfilemanager/widgets/selected_options/selected_items_options.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FileExplorerScreen extends StatelessWidget {
  final String location;
  bool hideLocation;

//-----------
  static Map<String, String> fileFolderSizeMemory = {};
  /*This fileFolderSizeMemory Keeps Calculated size of each folder in Memory
    Therefore whenever list View Builder tries to rebuild the fileFolderCard each time,
    the file folder is not calculated again, this reduces the cpu consumpition,
    This Map(fileFolderSizeMemory) is cleared whenever directory is changed 
    i.e new List View Builder is started building.
  */
//-----------------
  FileExplorerScreen(
      {super.key, required this.location, this.hideLocation = false});

  @override
  Widget build(BuildContext context) {
    fileFolderSizeMemory
        .clear(); //clearing the map when a new directory is opened

    // List<FileSystemEntity> dirItemsList = dirListItems(location);
    final String directoryTitle;

    // isSelectionModeActive.value =
    //     false; //Will be set to false when a new page builds.

    // context.read<SelectedItems>().items.clear();
    Provider.of<SelectedItems>(context, listen: false).items.clear();

    //selected items Will be cleared when a new page builds.

    if (location == internalRootDir || "$location/" == internalRootDir) {
      directoryTitle = 'Internal Storage';
    } else if (location == externalRootDir || "$location/" == externalRootDir) {
      directoryTitle = 'SD Card';
    } else if (location.contains(protectedDir.path)) {
      hideLocation = true;
      directoryTitle = "Protected Files";
    } else {
      directoryTitle = location.split('/').last;
    }
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
            copyButton(path: location),
            moveButton(path: location),
            selectedItemsOptions(),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _AppBarBottomSection(
                  hideLocation: hideLocation, location: location),
              FutureBuilder(
                  future: compute(dirListItems, location),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString() +
                          snapshot.connectionState.toString());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<FileSystemEntity> dirItemsList =
                        snapshot.data as List<FileSystemEntity>;
                    return Consumer<SelectedItems>(
                        builder: (context, selectedItems, child) {
                      return Expanded(
                        child: dirItemsList.isEmpty
                            ? const _EmptyFolderSection()
                            : _ListFileFoldersSection(
                                dirItemsList: dirItemsList,
                              ),
                      );
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarBottomSection extends StatelessWidget {
  const _AppBarBottomSection({
    Key? key,
    required this.hideLocation,
    required this.location,
  }) : super(key: key);

  final bool hideLocation;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorThemes>(
      builder: (context, colorThemes, child) => Container(
        padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: colorThemes.primaryColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(hideLocation ? '' : location)),
            InkWell(
              onTap: () {
                createNewFolder(context, location);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return FileExplorerScreen(location: location);
                  },
                ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.add), Text("New Folder")],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EmptyFolderSection extends StatelessWidget {
  const _EmptyFolderSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Folder is Empty",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class _ListFileFoldersSection extends StatelessWidget {
  const _ListFileFoldersSection({
    Key? key,
    required this.dirItemsList,
  }) : super(key: key);

  final List<FileSystemEntity> dirItemsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dirItemsList.length,
        itemBuilder: ((context, index) {
          return FutureBuilder(
              future: fileTypeThumbnail(dirItemsList[index].path),
              builder: (context, iconSnapshot) {
                Widget icon;
                if (iconSnapshot.connectionState != ConnectionState.done) {
                  icon = fileTypeIcon(location: dirItemsList[index].path);
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
        }));
  }
}
