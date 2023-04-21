import 'dart:io';

import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/selected_options/selected_properties_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

Widget selectedItemsOptions() {
  return Consumer<SelectedItems>(builder: (context, selectedItems, child) {
    return Visibility(
      visible: selectedItems.items.isNotEmpty,
      child: PopupMenuButton(
        onSelected: (value) async {
          switch (value) {
            case 0:
              context.read<ToMoveItems>().clear();
              // toMoveItems.value.clear();
              context.read<ToCopyItems>().clear();
              // toCopyItems.value.clear();
              context.read<ToCopyItems>().addAll(selectedItems.items);
              // toCopyItems.value.addAll(selectedItems.items);
              // toCopyItems.notifyListeners();
              // toMoveItems.notifyListeners();
              break;
            case 1:
              context.read<ToCopyItems>().clear();
              // toCopyItems.value.clear();
              context.read<ToMoveItems>().clear();

              // toMoveItems.value.clear();
              context.read<ToMoveItems>().addAll(selectedItems.items);

              // toMoveItems.value.addAll(selectedItems.items);
              // toMoveItems.notifyListeners();
              // toCopyItems.notifyListeners();
              break;
            case 2:
              String parentPath = selectedItems.items[0].parent.path;
              await deleteOperation(context, deleteItems: selectedItems.items);
              selectedItems.items.clear();
              selectedItems.notify();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return FileExplorerScreen(location: parentPath);
                },
              ));
              break;
            case 4:
              selectedPropertiesOptions(context,
                  selectedItems: selectedItems.items);
              break;
            case 5:
              Share.shareXFiles(
                  selectedItems.items.map((e) => XFile(e.path)).toList());
              break;
            default:
          }
        },
        itemBuilder: (context) {
          bool containsFolder = false;
          for (var item in selectedItems.items) {
            if (FileSystemEntity.isDirectorySync(item.path)) {
              containsFolder = true;
              break;
            }
          }
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text("Copy"),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text("Move"),
            ),
            const PopupMenuItem<int>(
              value: 2,
              child: Text("Delete"),
            ),
            const PopupMenuItem<int>(
              value: 3,
              child: Text("Hide Selected Files"),
            ),
            const PopupMenuItem<int>(
              value: 4,
              child: Text("Properties"),
            ),
            if (!containsFolder)
              const PopupMenuItem<int>(
                value: 5,
                child: Text("Share"),
              ),
          ];
        },
      ),
    );
  });
}
