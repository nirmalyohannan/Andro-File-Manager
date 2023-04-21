import 'dart:io';

import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';

// ValueNotifier<List<FileSystemEntity>> selectedItems =
//     ValueNotifier([]); //File Selection

// ValueNotifier<List<FileSystemEntity>> toMoveItems = ValueNotifier([]);
// ValueNotifier<List<FileSystemEntity>> toCopyItems = ValueNotifier([]);

class SelectedItems extends ChangeNotifier {
  List<FileSystemEntity> items = [];

  clear() {
    items.clear();
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  addOrRemove(FileSystemEntity fileSystemEntity) {
    if (containsPath(fileSystemEntity.path)) {
      items.removeWhere((element) => element.path == fileSystemEntity.path);
    } else {
      items.add(fileSystemEntity);
    }
    notifyListeners();
  }

  bool containsPath(String path) {
    return items.map((e) => e.path == path).contains(true);
  }
}

class ToMoveItems extends ChangeNotifier {
  List<FileSystemEntity> items = [];

  void clear() {
    items.clear();
    notifyListeners();
  }

  void add(FileSystemEntity fileSystemEntity) {
    items.add(fileSystemEntity);
    notifyListeners();
  }

  void addAll(List<FileSystemEntity> fileSystemEntityList) {
    items.addAll(fileSystemEntityList);
    notifyListeners();
  }
}

class ToCopyItems extends ChangeNotifier {
  List<FileSystemEntity> items = [];

  void clear() {
    items.clear();
    notifyListeners();
  }

  void add(FileSystemEntity fileSystemEntity) {
    items.add(fileSystemEntity);
    notifyListeners();
  }

  void addAll(List<FileSystemEntity> fileSystemEntityList) {
    items.addAll(fileSystemEntityList);
    notifyListeners();
  }
}

class ColorThemes extends ChangeNotifier {
  MaterialColor primaryColor = androPrimeColor;

  void notify() {
    notifyListeners();
  }
}
