import 'dart:io';

List<FileSystemEntity> dirListItems({required String location}) {
  Directory dir = Directory(location);
  return dir.listSync();
}
