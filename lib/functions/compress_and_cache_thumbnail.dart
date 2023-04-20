import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:androfilemanager/functions/native_call_media.dart';
import 'package:androfilemanager/thumbnail_database/thumbnail_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart' as Image;

class ThumbnailService {
  static final ThumbnailService instance = ThumbnailService._internal();
  factory ThumbnailService() {
    return instance;
  }
  ThumbnailService._internal();
//--------------------
  int processCount = 0;
  int queueCount = 0;

  static const maxProcessCount = 4;
//::::::::::::::::::::::::::::::::::::::::::::
  static Future<void> backgroundTask() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    ThumbnailDatabase.init();
    log('Calling get Medias from background Task');
    var pathList = await getMedias(MediaType.image);
    int index = 1;
    for (var path in pathList) {
      if (ThumbnailDatabase.isExists(path)) {
        continue;
      }

      if (File(path).lengthSync() < 1 * 1024 * 1024) {
        continue;
      }
      Uint8List? imageData = compressImage(path);
      if (imageData != null) {
        ThumbnailDatabase.add(path, imageData);
      }
      log('WorkManager: $index out of ${pathList.length} completed');
      index++;
    }
  }

//:::::::::::::::::::::::::::::::::::
  Future<Uint8List?> compressAndCacheThumbnail(String inputPath) async {
    if (ThumbnailDatabase.isExists(inputPath)) {
      if (inputPath.toLowerCase().contains('heic')) {
        log('HEIC THUMBNAIL OBTAINED FROM DATABSE');
      }
      return ThumbnailDatabase.get(inputPath);
    }

    File file = File(inputPath);
    if (file.lengthSync() < 1 * 1024 * 1024) {
      //return the same file if size is less than 1 mb
      //will not create thumbnail
      return file.readAsBytesSync();
    }
    queueCount++;
    log('Current Thumbnail Service Processing queue Count: $queueCount');
    // Future<File> file = FlutterNativeImage.compressImage(inputPath, quality: 5);
    //------------------------------------
    while (processCount >= maxProcessCount) {
      log('Current Thumbnail Service Processing process Count: $processCount');
      await Future.delayed(const Duration(milliseconds: 300));
    }
    processCount++;
    Uint8List? data = await compute(compressImage, inputPath);
    processCount--;
    queueCount--;
    log('Current Thumbnail Service Processing queue Count: $queueCount');
    if (data != null) {
      await ThumbnailDatabase.add(inputPath, data);
    }
    return data;
    //-------------------------------------
    // Timer.periodic(const Duration(milliseconds: 300), (timer) async {
    //   if (processCount < maxProcessCount) {
    //     processCount++;
    //     Uint8List? data = await compute(compressImage, inputPath);
    //     processCount--;
    //     queueCount--;
    //     log('Current Thumbnail Service Processing queue Count: $queueCount');
    //     if (data != null) {
    //       await ThumbnailDatabase.add(inputPath, data);
    //     }
    //     timer.cancel();
    //     // compute(saveThumbnail, ThumbnailData(File(inputPath), data));
    //   }
    // });
    // return file.readAsBytesSync();
  }

  // static void saveThumbnail(ThumbnailData thumbnailData) {
  //   log('Saving THumbnail');
  //   String parentPath = thumbnailData.originalFile.parent.path;
  //   if (parentPath.split('/').last == '.thumbnail') {
  //     return;
  //   }
  //   String thumbnailName = thumbnailData.originalFile.path.split('/').last;
  //   Directory('$parentPath/.thumbnail/').createSync();
  //   File thumbnailFile = File('$parentPath/.thumbnail/$thumbnailName');
  //   thumbnailFile.writeAsBytesSync(thumbnailData.data);
  //   log('Saving THumbnail Completed');
  // }
}

Uint8List? compressImage(String inputPath) {
  // Read the image file
  final File inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    return null;
  }

  final Uint8List inputBytes = inputFile.readAsBytesSync();
  final Image.Image? image = Image.decodeImage(inputBytes);
  if (image == null) {
    return null;
  }
  // Compress the image
  final Uint8List outputBytes = Image.encodeJpg(image, quality: 5);
  return outputBytes;
}

class ThumbnailData {
  File originalFile;
  Uint8List data;

  ThumbnailData(this.originalFile, this.data);
}
