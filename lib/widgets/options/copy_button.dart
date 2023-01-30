import 'package:androfilemanager/functions/alert_confirm.dart';
import 'package:androfilemanager/functions/file_operations.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget copyButton({required String path}) {
  return Consumer<ToCopyItems>(
    builder: (context, toCopyItems, child) {
      return Visibility(
          visible: toCopyItems.items.isNotEmpty,
          child: Row(
            children: [
              IconButton(
                  //Cancel Button
                  onPressed: () async {
                    if (await alertConfirm(context,
                        title: "Cancel?",
                        message: "Cancel the Copy operation?")) {
                      context.read<ToCopyItems>().clear();

                      // toCopyItems.value.clear();
                      // toCopyItems.notifyListeners();
                    }
                  },
                  icon: const Icon(Icons.cancel)),
              IconButton(
                icon: const Icon(Icons.paste),
                onPressed: () {
                  copyOperation(copyItems: toCopyItems.items, path: path);
                  context.read<ToCopyItems>().clear();

                  // toCopyItems.value.clear();
                  // toCopyItems.notifyListeners();
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
