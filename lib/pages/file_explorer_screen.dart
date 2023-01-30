import 'dart:developer';
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FileExplorerScreen extends StatelessWidget {
  final String location;
  bool hideLocation;
  FileExplorerScreen(
      {super.key, required this.location, this.hideLocation = false});

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> dirItemsList = dirListItems(location: location);
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
    return SafeArea(
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _AppBarBottomSection(hideLocation: hideLocation, location: location),
          Consumer<SelectedItems>(builder: (context, selectedItems, child) {
            return Expanded(
              child: dirItemsList.isEmpty
                  ? const _EmptyFolderSection()
                  : _ListFileFoldersSection(
                      dirItemsList: dirItemsList,
                      selectedItems: selectedItems.items),
            );
          }),
        ],
      ),
    ));
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [Icon(Icons.add), Text("New Folder")],
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
    required this.selectedItems,
  }) : super(key: key);

  final List<FileSystemEntity> dirItemsList;
  final List<FileSystemEntity> selectedItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: dirItemsList.length,
        itemBuilder: ((context, index) {
          Color folderColor = const Color.fromARGB(255, 230, 230, 230);
          if (selectedItems.contains(dirItemsList[index])) {
            log('::::::selected items contains true:::::::');
            folderColor = context.watch<ColorThemes>().primaryColor;
          }

          return FutureBuilder(
              future: fileTypeThumbnail(location: dirItemsList[index].path),
              builder: (context, iconSnapshot) {
                Widget icon;
                if (iconSnapshot.connectionState != ConnectionState.done) {
                  icon = fileTypeIcon(location: dirItemsList[index].path);
                } else {
                  icon = iconSnapshot.data!;
                }
                return fileFolderCard(context,
                    fileSystemEntity: dirItemsList[index],
                    icon: icon,
                    folderColor: folderColor);
              });
        }));
  }
}
