import 'dart:developer';
import 'dart:io';

//Calculate Directory/File size using Stream for better perfomance

Stream<int> directorySizeCalcStream(String location) async* {
  int size = 0;

  if (FileSystemEntity.isDirectorySync(location)) {
    try {
      List<FileSystemEntity> dirList =
          Directory(location).listSync(); //todo: Change Sync
      for (var i = 0; i < dirList.length; i++) {
        if (FileSystemEntity.isDirectorySync(dirList[i].path)) {
          directorySizeCalcStream(dirList[i].path).listen((event) {
            size = size + event;
          });
          yield size;
        } else {
          File file = File(dirList[i].path);
          file.length().then((value) {
            size = size + value;
          });
          yield size;
        }
      }
    } on FileSystemException {
      yield -1;
    }
  } else {
    File file = File(location);
    file.length().then((value) => size = size + value);
  }

  yield size;
}

Stream<String> readableDirSizeCalcStream(String location) async* {
  int size = 0;
  directorySizeCalcStream(location).listen((event) {
    size = event + size;
    log('::::$location ==== $event');
  });
  if (size == 0) {
    yield 'Empty Folder';
  } else if (size == -1) {
    yield 'size unknown';
  }
  double sizeMB = size / (1024 * 1024);
  if (sizeMB > 1024) {
    double sizeGB = sizeMB / 1024;
    yield '${sizeGB.toStringAsFixed(2)} GB';
  }

  yield '${sizeMB.toStringAsFixed(2)} MB';
}
