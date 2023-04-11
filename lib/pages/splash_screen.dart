import 'dart:developer';
import 'dart:io';

import 'package:androfilemanager/consts.dart';

import 'package:androfilemanager/functions/permissions.dart';

import 'package:androfilemanager/pages/home_screen.dart';
import 'package:androfilemanager/pages/terms_and_conditions_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/thumbnail_database/thumbnail_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../recent_files_database/recent_file_model.dart';

late SharedPreferences prefs;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    androFilesInit();
  }

  void androFilesInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(const Duration(milliseconds: 100));
    prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool("isFirstTime");
    if (isFirstTime == null || isFirstTime == false) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const TermsAndCondtionScreen();
        },
      ));
    } else {
      checkPermissions();
      internalRootDir = '${await storage.getInternalPath()}/';
      //::::::Hive Database App config::::::::::

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

      context.read<ColorThemes>().primaryColor =
          MsMaterialColor(int.parse(colorHex));
      //::::::Hive Databse Hidden Files:::::::::
      await Hive.openBox('appHideFiles');
      appHideFiles = Hive.box('appHideFiles');
      //::::::Hive Database Recent Files::::::::
      Hive.registerAdapter(RecentFileAdapter());
      await Hive.openBox('appRecentFiles');
      appRecentFiles = Hive.box('appRecentFiles');

//::::::::::::::::::;;;;;
      List<Directory>? storagesList = await getExternalStorageDirectories();
      if (storagesList != null) {
        if (storagesList.length > 1) {
          externalStorageExists = true;
          externalRootDir = storagesList[1].path.replaceAll(
              'Android/data/com.nirmalyohannan.AndroFiles/files', '');
          log("::::EXT PATH::::: $externalRootDir:::");
        }
      }

      await ThumbnailDatabase.init();
      //---------FileTypeScanning Starts here---------
      // FileTypeDatabase.init();
      // compute(scanFileType, internalRootDir);

      // if (externalRootDir != null) {
      //   compute(scanFileType, externalRootDir!);
      // }

      //----------------------------------------------

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
