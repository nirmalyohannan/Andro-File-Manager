//:::::::::::::MEDIA TYPES::::::::::::::::::::::::::

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<String> audioTypes = ['mp3', 'wav', 'aac', 'ogg', 'flac', 'm4a'];
List<String> videoTypes = ['mp4', 'mkv', 'avi', '3gp', 'm4v', 'webm', 'mov'];
List<String> documentTypes = ['pdf', 'docx', 'ppt', 'pptx', 'mobi', 'epub'];
List<String> imageTypes = ['jpeg', 'jpg', 'png', 'svg', 'heic'];
List<String> appTypes = ['apk'];
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::

//::::::::::::Directories:::::::::::::::::::::::::::
String internalRootDir =
    ''; //Internal storage path may vary for devices or OS versions, so have to find using function on app launch
bool externalStorageExists = false;
String?
    externalRootDir; //external storage path may vary for devices, so have to find using function on app launch

//:::::::::::::::::::::::::::::::::::::::::::::::::

//:::::::::::File Selection:::::::::::::::::::::::::

ValueNotifier<List<FileSystemEntity>> selectedItems = ValueNotifier([]);
//::::::::::::::::::::::::::::::::::::::::::::::::::

//::::::::::::App Theme::::::::::::::::
late Box appThemeBox;
//:::::::::::::::::::::::::::::::::::::

//:::::::::App Directory:::::::::::::::
late Directory protectedDir;
//::::::::::::::::::::::::::::::::
