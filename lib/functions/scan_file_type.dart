import 'dart:io';

List<FileSystemEntity> scanFileType(
    {required List<String> typesList, required String location}) {
  List<FileSystemEntity> typeFiles = [];
//:::::::::::::::::::::::::::::::::::::::
  if (FileSystemEntity.isDirectorySync(location)) {
    try {
      List<FileSystemEntity> dirList = Directory(location).listSync();
      for (var i = 0; i < dirList.length; i++) {
        if (FileSystemEntity.isDirectorySync(dirList[i].path)) {
          typeFiles.addAll(
              scanFileType(typesList: typesList, location: dirList[i].path));
        } else {
          if (checkFileType(
              typesList: typesList, fileSystemEntity: dirList[i])) {
            typeFiles.add(dirList[i]);
          }
        }
      }
    } on FileSystemException {
      return [];
    }
  }
//:::::::::::::::::::::::::::::::::

  return typeFiles;
}

bool checkFileType(
    {required List<String> typesList,
    required FileSystemEntity fileSystemEntity}) {
  bool isFileType = false;

  String extensionName = fileSystemEntity.path.split("/").last.split(".").last;
  for (var type in typesList) {
    if (type.contains(extensionName)) {
      isFileType = true;
      break;
    }
  }
  return isFileType;
}
