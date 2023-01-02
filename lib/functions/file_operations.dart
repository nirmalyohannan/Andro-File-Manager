import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/alert_confirm.dart';
import 'package:androfilemanager/functions/andro_snackbar.dart';
import 'package:flutter/material.dart';

void moveOperation(
    {required List<FileSystemEntity> moveItems, required String path}) {
  for (var element in moveItems) {
    String newPath = '${path}/${element.path.split("/").last}';
    newPath = newPath.replaceAll("//", "/");
    int num = 1;
    while (Directory(newPath).existsSync() || File(newPath).existsSync()) {
      if (FileSystemEntity.isFileSync(element.path)) {
        String fileName = element.path.split("/").last.split('.').first;
        String fileExtension = element.path.split("/").last.split('.').last;
        newPath = '$path/$fileName($num).$fileExtension';
      } else {
        newPath = '$path/${element.path.split("/").last}($num)';
      }

      print("path already exists Changing Name:: $newPath");
      num++;
    }
    //-----------------------------------------------
    if (FileSystemEntity.isFileSync(element.path)) {
      print("Moving a File: ${element.path}");
      print("to: $newPath");
      try {
        element.renameSync(newPath);
      } on FileSystemException {
        print("Move Failed: Trying Copy and Delete Method");
        File(element.path).copySync(newPath);
        element.deleteSync();
      } catch (e) {
        print("Move Failed!!!!");
      }
    } //------------If it is a folder---------------------
    else {
      print("Moving a folder: ${element.path}");
      print("to: $newPath");
      Directory(newPath).createSync();
      moveOperation(
          moveItems: Directory(element.path).listSync(), path: newPath);
    }
    if (element.existsSync()) {
      element.deleteSync();
    }
  }
}

Future<void> deleteOperation(BuildContext context,
    {required List<FileSystemEntity> deleteItems}) async {
  if (await alertConfirm(context,
      title: "Delete",
      message: "Do you wish to Delete selected ${deleteItems.length} items")) {
    for (var i = 0; i < deleteItems.length; i++) {
      try {
        deleteItems[i].deleteSync();
      } catch (e) {
        androSnackBar(context, message: "Problem Deleting 1 file or Folder");
      }
    }
    androSnackBar(context, message: "Deletion Completed");
  } else {
    androSnackBar(context, message: "Deletion Canceled");
  }
}

void copyOperation(
    {required List<FileSystemEntity> copyItems, required String path}) {
  for (var element in copyItems) {
    log("Copying Operation::::");
    String newPath = '${path}/${element.path.split("/").last}';
    newPath = newPath.replaceAll("//", "/");
    int num = 1;

    while (Directory(newPath).existsSync() || File(newPath).existsSync()) {
      if (FileSystemEntity.isFileSync(element.path)) {
        String fileName = element.path.split("/").last.split('.').first;
        String fileExtension = element.path.split("/").last.split('.').last;
        newPath = '$path/$fileName($num).$fileExtension';
      } else {
        newPath = '$path/${element.path.split("/").last}($num)';
      }

      print("path already exists Changing Name:: $newPath");
      num++;
    }
    //-----------------------------------------------
    if (FileSystemEntity.isFileSync(element.path)) {
      print("Copying a File: ${element.path}");
      print("to: $newPath");
      try {
        File(element.path).copySync(newPath);
      } catch (e) {
        print("copy Failed!!!!");
      }
    } //------------If it is a folder---------------------
    else {
      print("Copying a folder: ${element.path}");
      print("to: $newPath");
      Directory(newPath).createSync();
      copyOperation(
          copyItems: Directory(element.path).listSync(), path: newPath);
    }
  }
}

void hideOperation({required List<FileSystemEntity> toHideFiles}) {
  for (int index = 0; index < toHideFiles.length; index++) {
    var file = toHideFiles[index];
    String fileName = file.path.replaceAll('${file.parent.path}/', "");
    String fileOriginalPath = file.parent.path;
    appHideFiles.put(fileName, fileOriginalPath);
  }
  log("Files Path Saved to Database");
  log("Hiding Files");
  moveOperation(moveItems: toHideFiles, path: protectedDir.path);
}

void unHideOperation({required List<FileSystemEntity> toUnHideFiles}) {
  for (int index = 0; index < toUnHideFiles.length; index++) {
    var file = toUnHideFiles[index];
    String fileName = file.path.replaceAll('${file.parent.path}/', "");
    String fileOriginalPath =
        appHideFiles.get(fileName, defaultValue: internalRootDir);
    moveOperation(moveItems: [file], path: fileOriginalPath);
  }
  log("unHided Successfully!!");
}
