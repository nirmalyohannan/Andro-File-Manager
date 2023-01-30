import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
          title: 'Andro File Manager',
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
