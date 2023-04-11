import 'dart:io';

List<FileSystemEntity> dirListItems(String location) {
  Directory dir = Directory(location);
  return dir.listSync();
}
