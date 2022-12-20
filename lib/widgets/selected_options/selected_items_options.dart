import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/widgets/selected_options/selected_properties_options.dart';
import 'package:flutter/material.dart';

Widget selectedItemsOptions() {
  return ValueListenableBuilder(
      valueListenable: selectedItems,
      builder: (context, items, child) {
        return Visibility(
          visible: items.isNotEmpty,
          child: PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case 1:
                  toMoveItems.value.clear();
                  toMoveItems.value.addAll(items);
                  toMoveItems.notifyListeners();
                  break;
                case 2:
                  await deleteOperation(context, deleteItems: items);
                  selectedItems.value.clear();
                  selectedItems.notifyListeners();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return FileExplorerScreen(
                        location: items[0].parent.path,
                      );
                    },
                  ));
                  break;
                case 4:
                  selectedPropertiesOptions(context, selectedItems: items);
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Copy"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Move"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Delete"),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text("Hide Selected Files"),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Text("Properties"),
                ),
              ];
            },
          ),
        );
      });
}
