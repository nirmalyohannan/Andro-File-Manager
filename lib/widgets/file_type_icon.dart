import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../consts.dart';

Widget fileTypeIcon({required String location, double iconSize = 40}) {
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
      // return Image.file(
      //   File(location),
      //   filterQuality: FilterQuality.none,
      // );
      return Icon(Icons.image_outlined, size: iconSize);
    } else if (appTypes.contains(extension)) {
      return Icon(Icons.android, size: iconSize);
    } else {
      return Icon(Icons.file_copy, size: iconSize);
    }
  }
}

Future<Widget> fileTypeThumbnail(
    {required String location, double iconSize = 40}) async {
  if (FileSystemEntity.isDirectorySync(location)) {
    return Icon(Icons.folder_open_outlined, size: iconSize);
  } else {
    String extension = location.split('.').last.toLowerCase();

    if (audioTypes.contains(extension)) {
      return Icon(Icons.audio_file_outlined, size: iconSize);
    } else if (videoTypes.contains(extension)) {
      // return Icon(Icons.video_file_outlined, size: iconSize);
      Uint8List? videoFile =
          await VideoThumbnail.thumbnailData(video: location);
      if (videoFile == null) {
        return Icon(Icons.video_file_outlined, size: iconSize);
      } else {
        return Stack(
          children: [
            Image.memory(videoFile),
            const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.video_file_outlined,
                ))
          ],
        );
      }
    } else if (documentTypes.contains(extension)) {
      return Icon(Icons.file_copy_outlined, size: iconSize);
    } else if (imageTypes.contains(extension)) {
      return Image.file(
        File(location),
        filterQuality: FilterQuality.none,
      );
    } else if (appTypes.contains(extension)) {
      return Icon(Icons.android, size: iconSize);
    } else {
      return Icon(Icons.file_copy, size: iconSize);
    }
  }
}
