//This Widget is a card in File explorer screens where File or Folder will be
//represented as a Card with File/Folder icon, Name, size, option button

import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/dir_size_calc.dart';
import 'package:androfilemanager/functions/open_dir.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/file_folder_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget fileFolderCard(BuildContext context,
    {required FileSystemEntity fileSystemEntity,
    required Widget icon,
    required Color folderColor}) {
  //Color folderColor = Color.fromARGB(255, 230, 230, 230);
  // ValueNotifier<Color> folderColor =
  //     ValueNotifier(const Color.fromARGB(255, 230, 230, 230));

  String path = fileSystemEntity.path;
  // String folderSize = showFolderSize ? readableDirSizeCalc(path) : '';
  return InkWell(
      splashFactory: InkRipple.splashFactory,
      splashColor: context.read<ColorThemes>().primaryColor,
      onTap: () {
        List<FileSystemEntity> selectedItems =
            context.read<SelectedItems>().items;

        if (selectedItems.isNotEmpty) {
          if (selectedItems.contains(fileSystemEntity) == false) {
            selectedItems.add(fileSystemEntity);
            context.read<SelectedItems>().items = selectedItems;
            context.read<SelectedItems>().notify();

            // print(selectedItems.value);
          } else {
            // print('unselect');
            selectedItems.remove(fileSystemEntity);
            context.read<SelectedItems>().items = selectedItems;
            context.read<SelectedItems>().notify();

            // print(selectedItems.value);
          }
        } else {
          openDir(context, location: path, fileSystemEntity: fileSystemEntity);
        }
      },
      onLongPress: () {
        List<FileSystemEntity> selectedItems =
            context.read<SelectedItems>().items;
        if (selectedItems.contains(fileSystemEntity) == false) {
          selectedItems.add(fileSystemEntity);
          context.read<SelectedItems>().items = selectedItems;
          context.read<SelectedItems>().notify();

          // print(selectedItems.value);
        } else {
          // print('::::${selectedItems.value.remove(fileSystemEntity)}');
          context.read<SelectedItems>().items = selectedItems;
          context.read<SelectedItems>().notify();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: folderColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: ListTile(
          iconColor: Colors.black,
          leading: icon,
          title: Text(path.split('/').last),
          subtitle: FutureBuilder(
              future: compute(readableDirSizeCalc, path),
              builder: (context, folderSize) {
                return Text(folderSize.hasData ? folderSize.data ?? '' : '');
              }),
          trailing: Visibility(
            visible: context.read<SelectedItems>().items.isEmpty,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              iconSize: 30,
              onPressed: () {
                fileFolderOptions(context, fileSystemEntity: fileSystemEntity);
              },
            ),
          ),
        ),
      )
      // ;})
      );
}
