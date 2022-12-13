import 'package:flutter/services.dart';

class Storage {
  late MethodChannel channel;
  Storage() {
    channel = const MethodChannel('Storage');
  }
  Future<int> totalInternalBytes() async {
    int gbTotal = await channel.invokeMethod('getInternalTotalSpace');
    return gbTotal;
  }

  Future<int> freeInternalBytes() async {
    int gbFree = await channel.invokeMethod('getInteralFreeSpace');
    return gbFree;
  }

  Future<int> totalExternalBytes() async {
    int gbTotal = await channel.invokeMethod('getExternalTotalSpace');
    return gbTotal;
  }

  Future<int> freeExternalBytes() async {
    int gbFree = await channel.invokeMethod('getExternalFreeSpace');
    return gbFree;
  }

  Future<String> getInternalPath() async {
    return await channel.invokeMethod('getInternalPath');
  }
}
