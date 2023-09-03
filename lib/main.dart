import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
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
