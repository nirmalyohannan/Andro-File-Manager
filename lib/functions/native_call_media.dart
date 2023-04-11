import 'dart:developer';

import 'package:flutter/services.dart';

const platform = MethodChannel('Media');

enum MediaType { image, video, audio, document, app }

Future<List<String>> getMedias(MediaType type) async {
  try {
    log(type.toString());
    final List<dynamic> result =
        await platform.invokeMethod('getMedias', {'type': type.toString()});
    // List<String>.from(result).sort(
    //   (a, b) {
    //     log(File(a).lastModifiedSync().toString());
    //     return File(b).lastModifiedSync().isAfter(File(a).lastModifiedSync())
    //         ? -1
    //         : 1;
    //   },
    // );
    return List<String>.from(result).reversed.toList();
  } on PlatformException catch (e) {
    log("Failed to get medias: '${e.message}'.");
    return [];
  }
}
