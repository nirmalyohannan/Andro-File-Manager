import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/selected_options/selected_properties_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
