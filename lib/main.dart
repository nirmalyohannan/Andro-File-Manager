import 'dart:developer';

import 'package:androfilemanager/functions/compress_and_cache_thumbnail.dart';
import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     log('Starting BackGround Task: Thumbnail Service background task');
//     try {
//       await ThumbnailService.backgroundTask();
//     } catch (e) {
//       log('THumbnail Service background task failed');
//       log(e.toString());
//     }
//     return Future.value(true);
//   });
// }

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // //-----------------------------
  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager().registerPeriodicTask(
  //     "ThumbnailService", "ThumbnailService.backgroundTask",
  //     frequency: const Duration(minutes: 15));
  //---------------------------
  runApp(const AndroFileManager());
}

class AndroFileManager extends StatelessWidget {
  const AndroFileManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<SelectedItems>(create: (context) => SelectedItems()),
        ListenableProvider<ToMoveItems>(create: (context) => ToMoveItems()),
        ListenableProvider<ToCopyItems>(create: (context) => ToCopyItems()),
        ListenableProvider<ColorThemes>(create: (context) => ColorThemes())
      ],
      child: Consumer<ColorThemes>(
        builder: (context, colorThemes, child) => MaterialApp(
          theme: ThemeData(primarySwatch: colorThemes.primaryColor),
          debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          title: 'Andro File Manager',
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
