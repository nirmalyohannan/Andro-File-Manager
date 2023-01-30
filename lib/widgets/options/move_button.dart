import 'package:androfilemanager/functions/alert_confirm.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget moveButton({required String path}) {
  return Consumer<ToMoveItems>(
    builder: (context, toMoveItems, child) {
      return Visibility(
          visible: toMoveItems.items.isNotEmpty,
          child: Row(
            children: [
              IconButton(
                  //Cancel Button
                  onPressed: () async {
                    if (await alertConfirm(context,
                        title: "Cancel?",
                        message: "Cancel the Move operation?")) {
                      toMoveItems.clear();
                    }
                  },
                  icon: const Icon(Icons.cancel)),
              IconButton(
                icon: const Icon(Icons.paste),
                onPressed: () {
                  moveOperation(moveItems: toMoveItems.items, path: path);
                  toMoveItems.clear();

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
