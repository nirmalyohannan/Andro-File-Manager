import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/color_picker.dart';
// import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';

import '../widgets/diskspace_tile.dart';
import '../widgets/icon_tile.dart';
import '../widgets/tile_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: primaryColor,
              builder: (context, mainColor, child) => Container(
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Image.asset(
                        'assets/logo/AndroLogo.png',
                        width: MediaQuery.of(context).size.width / 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //:::::::::Settings Items::::::::

            tileButton(
              icon: Icons.color_lens,
              title: 'Change Theme',
              onPressed: () {
                colorPicker(context);
              },
            ),

            tileButton(icon: Icons.document_scanner, title: 'About App'),
          ],
        ),
      ),
    );
  }
}
