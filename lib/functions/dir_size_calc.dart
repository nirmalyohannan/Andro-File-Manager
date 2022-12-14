import 'dart:io';

int directorySizeCalc(String location) {
  int size = 0;

  if (FileSystemEntity.isDirectorySync(location)) {
    try {
      List<FileSystemEntity> dirList = Directory(location).listSync();
      for (var i = 0; i < dirList.length; i++) {
        if (FileSystemEntity.isDirectorySync(dirList[i].path)) {
          size = size + directorySizeCalc(dirList[i].path);
        } else {
          File file = File(dirList[i].path);
          size = size + file.lengthSync();
        }
      }
    } on FileSystemException {
      return -1;
    }
  } else {
    File file = File(location);
    size = size + file.lengthSync();
  }

  return size;
}

String readableDirSizeCalc(String location) {
  int size = directorySizeCalc(location);
  if (size == 0) {
    return 'Empty Folder';
  } else if (size == -1) {
    return 'size unknown';
  }
  double sizeMB = size / (1024 * 1024);
  if (sizeMB > 1024) {
    double sizeGB = sizeMB / 1024;
    return '${sizeGB.toStringAsFixed(2)} GB';
  }

  return '${sizeMB.toStringAsFixed(2)} MB';
}
