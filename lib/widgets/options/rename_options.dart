import 'dart:io';

import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:flutter/material.dart';

//*! Alert: Add Validators for:
//*! If the name already exists,
//*! If the name contains special characters

void renameOptions(BuildContext context,
    {required FileSystemEntity fileSystemEntity}) {
  showDialog(
    context: context,
    builder: (context) {
      List<String> temp = fileSystemEntity.path.split("/").last.split(".");
      List<String> temp2 = fileSystemEntity.path.split("/");
      temp2.removeLast();
      String fileLocation = "${temp2.join("/")}/";
      String fileExtension;
      String fileName;

      GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
            key: formKey,
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
                return null;
              },
              onChanged: (value) {
                formKey.currentState!.validate();
              },
              onEditingComplete: () {
                if (formKey.currentState!.validate()) {
                  print("$fileLocation${controller.text}$fileExtension");
                  try {
                    fileSystemEntity.renameSync(
                        "$fileLocation/${controller.text}$fileExtension");
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Rename Failed!")));
                  }

                  textFormNode.unfocus();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FileExplorerScreen(location: fileLocation),
                    ),
                  );
                }
              },
            ),
          )
        ],
      );
    },
  );
}
