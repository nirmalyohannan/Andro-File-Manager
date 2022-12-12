import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/disk_space.dart';
import 'package:androfilemanager/functions/permissions.dart';

import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

DiskSpace diskSpace = DiskSpace();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkPermissions();

  List<Directory>? storagesList = await getExternalStorageDirectories();
  if (storagesList != null) {
    if (storagesList.length > 1) {
      externalStorageExists = true;
      externalRootDir = storagesList[1]
          .path
          .replaceAll('Android/data/com.example.androfilemanager/files', '');
      log("::::EXT PATH::::: $externalRootDir:::");
    }
  }

  log(':::::${await diskSpace.totalInternalBytes()}::::');
  log(':::::${await diskSpace.freeInternalBytes()}::::');
  if (externalStorageExists) {
    log(':::::${await diskSpace.totalExternalBytes()}::::');
    log(':::::${await diskSpace.freeExternalBytes()}::::');
  }
  runApp(const AndroFileManager());
}

class AndroFileManager extends StatelessWidget {
  const AndroFileManager({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: primaryColor,
      builder: (context, mainColor, child) => MaterialApp(
        theme: ThemeData(primarySwatch: mainColor),
        debugShowCheckedModeBanner: false,
        title: 'Andro File Manager',
        home: const HomeScreen(),
      ),
    );
  }
}
