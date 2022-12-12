import 'dart:io';

import 'package:flutter/material.dart';

import '../consts.dart';

Icon fileTypeIcon({required String location, double iconSize = 40}) {
  if (FileSystemEntity.isDirectorySync(location)) {
    return Icon(Icons.folder_open_outlined, size: iconSize);
  } else {
    String extension = location.split('.').last.toLowerCase();

    if (audioTypes.contains(extension)) {
      return Icon(Icons.audio_file_outlined, size: iconSize);
    } else if (videoTypes.contains(extension)) {
      return Icon(Icons.video_file_outlined, size: iconSize);
    } else if (documentTypes.contains(extension)) {
      return Icon(Icons.file_copy_outlined, size: iconSize);
    } else if (imageTypes.contains(extension)) {
      return Icon(Icons.image_outlined, size: iconSize);
    } else if (appTypes.contains(extension)) {
      return Icon(Icons.android, size: iconSize);
    } else {
      return Icon(Icons.file_copy, size: iconSize);
    }
  }
}
