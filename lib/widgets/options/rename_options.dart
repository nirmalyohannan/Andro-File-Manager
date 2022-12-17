import 'dart:io';

import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:flutter/material.dart';

void renameOptions(BuildContext context,
    {required FileSystemEntity fileSystemEntity}) {
  showDialog(
    context: context,
    builder: (context) {
      List<String> temp = fileSystemEntity.path.split("/").last.split(".");
      List<String> temp2 = fileSystemEntity.path.split("/");
      temp2.removeLast();
      String fileLocation = temp2.join("/");
      String fileExtension;
      String fileName;

      GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      if (temp.length > 1) {
        fileExtension = ".${temp.removeLast()}";
        fileName = temp.join(".");
      } else {
        fileName = temp.join();
        fileExtension = "";
      }
      TextEditingController controller = TextEditingController(text: fileName);
      FocusNode textFormNode = FocusNode();
      return AlertDialog(
        title: const Text("Rename"),
        actions: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              focusNode: textFormNode,
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Name cannot be empty";
                  }
                } else if (value == null) {
                  return "Name cannot be empty";
                }
              },
              onChanged: (value) {
                _formKey.currentState!.validate();
              },
              onEditingComplete: () {
                if (_formKey.currentState!.validate()) {
                  print("$fileLocation/${controller.text}$fileExtension");
                  fileSystemEntity.renameSync(
                      "$fileLocation/${controller.text}$fileExtension");
                  textFormNode.unfocus();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FileExplorerScreen(location: "$fileLocation/"),
                      ));
                }
              },
            ),
          )
        ],
      );
    },
  );
}