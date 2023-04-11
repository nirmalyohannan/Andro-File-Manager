import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThumbnailDatabase {
  static late Box box;

  static init() async {
    box = await Hive.openBox('ThumbnailDatabase');
  }

  static Future<void> add(String location, Uint8List data) async {
    await box.put(location, data);
  }

  static bool isExists(String location) {
    return box.keys.contains(location);
  }

  static Uint8List get(String location) {
    return box.get(location);
  }
}
