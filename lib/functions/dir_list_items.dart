import 'dart:io';

List<FileSystemEntity> dirListItems(String location) {
  Directory dir = Directory(location);
  List<FileSystemEntity> allItems = dir.listSync();

  List<FileSystemEntity> folders = [];
  List<FileSystemEntity> files = [];

  for (var item in allItems) {
    if (FileSystemEntity.isDirectorySync(item.path)) {
      folders.add(item);
    } else {
      files.add(item);
    }
  }
  return [...folders, ...files];
}
