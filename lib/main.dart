import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/disk_space.dart';
import 'package:androfilemanager/functions/permissions.dart';

import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';
import 'package:path_provider/path_provider.dart';

DiskSpace diskSpace = DiskSpace();
void main() async {
  //todo:Move These Tasks to Splash Screen

  WidgetsFlutterBinding.ensureInitialized();
  checkPermissions();
  //::::::Hive Database App Theme::::::::::
  await Hive.initFlutter();
  await Hive.openBox('AppTheme');
  appThemeBox = Hive.box('AppTheme');
  int red = appThemeBox.get('colorRed', defaultValue: androPrimeColor.red);
  int green =
      appThemeBox.get('colorGreen', defaultValue: androPrimeColor.green);
  int blue = appThemeBox.get('colorBlue', defaultValue: androPrimeColor.blue);
  String colorHex = ColorConvert.rgbToHex(r: red, b: blue, g: green);
  colorHex = '0xFF${colorHex.replaceAll('#', '')}';

  primaryColor.value = MsMaterialColor(int.parse(colorHex));
//::::::::::::::::::;;;;;
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
