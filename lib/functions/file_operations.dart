import 'dart:io';

void moveOperation(
    {required List<FileSystemEntity> moveItems, required String path}) {
  for (var element in moveItems) {
    String newPath = '${path}/${element.path.split("/").last}';
    newPath = newPath.replaceAll("//", "/");
    int num = 1;
    while (Directory(newPath).existsSync()) {
      newPath = '${path}/${element.path.split("/").last}($num)';
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
