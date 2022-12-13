import 'package:flutter/services.dart';

Future<int> getAndroidVersionInt() async {
  MethodChannel channel = const MethodChannel("Android");
  return await channel.invokeMethod("getAndroidVersionInt");
}
