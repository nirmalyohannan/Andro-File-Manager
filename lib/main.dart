import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';

//todo: Change Android Data open folder (if) permisson error snackBar to Try Catch

void main() {
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
        home: const SplashScreen(),
      ),
    );
  }
}
