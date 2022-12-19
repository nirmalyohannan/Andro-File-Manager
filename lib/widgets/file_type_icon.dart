import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../consts.dart';

Widget fileTypeIcon({required String location, double iconSize = 40}) {
  if (FileSystemEntity.isDirectorySync(location)) {
    return Icon(Icons.folder_open_outlined, size: iconSize);
  } else {
    String extension = location.split('.').last.toLowerCase();

    if (audioTypes.contains(extension)) {
      return Image.asset(iconPathAudio);
    } else if (videoTypes.contains(extension)) {
      return Image.asset(iconPathVideo);
    } else if (documentTypes.contains(extension)) {
      return Icon(Icons.file_copy_outlined, size: iconSize);
    } else if (imageTypes.contains(extension)) {
      // return Image.file(
      //   File(location),
      //   filterQuality: FilterQuality.none,
      // );
      return Image.asset(iconPathImage);
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
      return Image.asset(iconPathAudio);
    } else if (videoTypes.contains(extension)) {
      // return Icon(Icons.video_file_outlined, size: iconSize);
      Uint8List? videoFile;
      try {
        videoFile = await VideoThumbnail.thumbnailData(video: location);
      } catch (e) {
        ByteData bytes = await rootBundle.load(iconPathVideo);
        videoFile = bytes.buffer.asUint8List();
      }

      if (videoFile == null) {
        return Icon(Icons.video_file_outlined, size: iconSize);
      } else {
        return Stack(
          children: [
            Image.memory(videoFile),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: iconSize / 1.5,
                child: Image.asset(
                  iconPathVideo,
                  fit: BoxFit.contain,
                ),
              ),
            )
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
      return Image.asset(iconPathAPK);
    } else {
      return Icon(Icons.file_copy, size: iconSize);
    }
  }
}
