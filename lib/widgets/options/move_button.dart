import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/alert_confirm.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:flutter/material.dart';

Widget moveButton({required String path}) {
  return ValueListenableBuilder(
    valueListenable: toMoveItems,
    builder: (context, items, child) {
      return Visibility(
          visible: items.isNotEmpty,
          child: Row(
            children: [
              IconButton(
                  //Cancel Button
                  onPressed: () async {
                    if (await alertConfirm(context,
                        title: "Cancel?",
                        message: "Cancel the Move operation?")) {
                      toMoveItems.value.clear();
                      toMoveItems.notifyListeners();
                    }
                  },
                  icon: const Icon(Icons.cancel)),
              IconButton(
                icon: const Icon(Icons.paste),
                onPressed: () {
                  moveOperation(moveItems: toMoveItems.value, path: path);
                  toMoveItems.value.clear();
                  toMoveItems.notifyListeners();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FileExplorerScreen(location: path),
                      ));
                },
              ),
            ],
          ));
    },
  );
}
