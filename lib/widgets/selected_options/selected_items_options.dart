import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/widgets/selected_options/selected_properties_options.dart';
import 'package:flutter/material.dart';

Widget selectedItemsOptions() {
  return ValueListenableBuilder(
      valueListenable: selectedItems,
      builder: (context, selectedItems, child) {
        return Visibility(
          visible: selectedItems.isNotEmpty,
          child: PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 1:
                  toMoveItems.value.clear();
                  toMoveItems.value.addAll(selectedItems);
                  toMoveItems.notifyListeners();
                  break;
                case 4:
                  selectedPropertiesOptions(context,
                      selectedItems: selectedItems);
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
