import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/functions/compress_and_cache_thumbnail.dart';
import 'package:androfilemanager/thumbnail_database/thumbnail_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
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

Future<Widget> fileTypeThumbnail(String location,
    [double iconSize = 40]) async {
  if (FileSystemEntity.isDirectorySync(location)) {
    return Icon(Icons.folder_open_outlined, size: iconSize);
  } else {
    String extension = location.split('.').last.toLowerCase();

    if (audioTypes.contains(extension)) {
      return Image.asset(iconPathAudio);
    } else if (videoTypes.contains(extension)) {
      // return Icon(Icons.video_file_outlined, size: iconSize);

      Uint8List? videoFile;
      if (ThumbnailDatabase.isExists(location)) {
        videoFile = ThumbnailDatabase.get(location);
      } else {
        try {
          videoFile = await VideoThumbnail.thumbnailData(video: location);
        } catch (e) {
          ByteData bytes = await rootBundle.load(iconPathVideo);
          videoFile = bytes.buffer.asUint8List();
        }

        if (videoFile == null) {
          return Icon(Icons.video_file_outlined, size: iconSize);
        }
      }
      ThumbnailDatabase.add(location, videoFile);
      return SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Image.memory(
              videoFile,
              filterQuality: FilterQuality.none,
              fit: BoxFit.cover,
            ),
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
        ),
      );
    } else if (documentTypes.contains(extension)) {
      return Icon(Icons.file_copy_outlined, size: iconSize);
    } else if (imageTypes.contains(extension)) {
      // File file;
      Uint8List imageData;
      try {
        // file = File(location);
        imageData = await ThumbnailService.instance
                .compressAndCacheThumbnail(location) ??
            File(location).readAsBytesSync();

        // file = await FlutterNativeImage.compressImage(location, quality: 5);
        // log(file.lengthSync().toString());
        // if (file.lengthSync() == 0) {
        //   throw StateError("The file is empty as an image");
        // }
        if (imageData.isEmpty) {
          throw StateError("The file is empty as an image");
        }
      } on StateError {
        return noImagePreviewWidget();
      } catch (e) {
        log("Thumbnail not loaded");
        log(e.toString());
        // file = File(iconPathImage);
        ByteData bytes = await rootBundle.load(iconPathImage);
        imageData = bytes.buffer.asUint8List();
      }
      return SizedBox(
        height: 50,
        width: 50,
        child: Image.memory(imageData,
            filterQuality: FilterQuality.none,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                noImagePreviewWidget()),
      );
    } else if (appTypes.contains(extension)) {
      return Image.asset(iconPathAPK);
    } else {
      return Icon(Icons.file_copy, size: iconSize);
    }
  }
}

Stack noImagePreviewWidget() {
  return Stack(
    alignment: AlignmentDirectional.bottomEnd,
    children: [
      Opacity(
        opacity: 0.4,
        child: LottieBuilder.asset(
          lottieImageLoading,
          width: 50,
        ),
      ),
      const Icon(Icons.cancel)
    ],
  );
}
