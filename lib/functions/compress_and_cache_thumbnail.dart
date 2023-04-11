import 'dart:io';
import 'dart:typed_data';
import 'package:androfilemanager/thumbnail_database/thumbnail_database.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart';

Future<Uint8List?> compressAndCacheThumbnail(String inputPath) async {
  // return File.fromRawPath(outputBytes);
  if (ThumbnailDatabase.isExists(inputPath)) {
    return ThumbnailDatabase.get(inputPath);
  }
  // Future<File> file = FlutterNativeImage.compressImage(inputPath, quality: 5);
  Uint8List? data = await compute(compressImage, inputPath);
  if (data == null) {
    return null;
  }
  ThumbnailDatabase.add(inputPath, data);
  return data;
}

Uint8List? compressImage(String inputPath) {
  // Read the image file
  final File inputFile = File(inputPath);
  if (!inputFile.existsSync()) {
    return null;
  }
  final Uint8List inputBytes = inputFile.readAsBytesSync();
  final Image? image = decodeImage(inputBytes);
  if (image == null) {
    return null;
  }
  // Compress the image
  final Uint8List outputBytes = encodeJpg(image, quality: 5);
  return outputBytes;
}
