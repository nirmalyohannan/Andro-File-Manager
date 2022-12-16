import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/authentication.dart';
import 'package:androfilemanager/functions/permissions.dart';
import 'package:androfilemanager/main.dart';
import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    androFilesInit();
  }

  void androFilesInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    checkPermissions();
    internalRootDir = '${await storage.getInternalPath()}/';
    //::::::Hive Database App Theme::::::::::
    await Hive.initFlutter();
    await Hive.openBox('appConfig');
    appConfigBox = Hive.box('appConfig');
    showFolderSize = appConfigBox.get('showFolderSize', defaultValue: false);
    int red = appConfigBox.get('colorRed', defaultValue: androPrimeColor.red);
    int green =
        appConfigBox.get('colorGreen', defaultValue: androPrimeColor.green);
    int blue =
        appConfigBox.get('colorBlue', defaultValue: androPrimeColor.blue);
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

    log(':::::${await storage.totalInternalBytes()}::::');
    log(':::::${await storage.freeInternalBytes()}::::');
    if (externalStorageExists) {
      log(':::::${await storage.totalExternalBytes()}::::');
      log(':::::${await storage.freeExternalBytes()}::::');
    }
    //:::::::::::::protected Directory:::::::::::;
    String appDocumentPath =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    String protectedFilesPath = '$appDocumentPath/Protected Files';

    protectedDir = Directory(protectedFilesPath);
    protectedDir.createSync();
    //::::::::::::::::::::::::::::::::::::::
    // await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo/AndroLogo.png',
          width: 250,
        ),
      ),
    ));
  }
}
