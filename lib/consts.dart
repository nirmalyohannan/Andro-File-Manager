//:::::::::::::MEDIA TYPES::::::::::::::::::::::::::

import 'dart:io';

import 'package:androfilemanager/functions/storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

//::::::::Icons Path:::::::::::::::::::::::
String iconPathVideo = "assets/Icons/video.png";
String iconPathAudio = "assets/Icons/audio.png";
String iconPathImage = "assets/Icons/image.png";
String iconPathDocument = "assets/Icons/document.png";
String iconPathFolder = "assets/Icons/folder.png";
String iconPathAPK = "assets/Icons/apk.png";

//:::::::::File Types::::::::::::::::::
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
//:::::::::::::::::::::::::::::::::::::::::::::::::::

ValueNotifier<List<FileSystemEntity>> selectedItems =
    ValueNotifier([]); //File Selection
ValueNotifier<List<FileSystemEntity>> toMoveItems = ValueNotifier([]);

ValueNotifier<List<FileSystemEntity>> toCopyItems = ValueNotifier([]);

//::::::::::::App Config::::::::::::::::
late Box appConfigBox;
bool showFolderSize = false;
//:::::::::::::::::::::::::::::::::::::

//::::::::::App Hidden Files::::::::::
late Box appHideFiles;

//:::::::::App Directory:::::::::::::::
late Directory protectedDir;
//::::::::::::::::::::::::::::::::

Storage storage = Storage();//storage related method channel functionalities
