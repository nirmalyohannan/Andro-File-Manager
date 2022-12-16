import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/color_picker.dart';
import 'package:flutter/material.dart';

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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          'assets/logo/AndroLogo.png',
                          width: MediaQuery.of(context).size.width / 1.7,
                        ),
                      ),
                      const Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //:::::::::Settings Items::::::::

            SwitchListTile(
              title: const Text('Show folder size with folder (Beta)'),
              value: showFolderSize,
              onChanged: (value) {
                setState(() {
                  showFolderSize = value ? true : false;
                });
                appConfigBox.put('showFolderSize', showFolderSize);
                if (value == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Enabling 'Show folder size with folder' may affect app perfomance")));
                }
              },
            ),
            tileButton(
              icon: Icons.color_lens,
              title: 'Change Theme',
              onPressed: () {
                colorPicker(context);
              },
            ),

            tileButton(
              icon: Icons.document_scanner,
              title: 'About App',
            ),
          ],
        ),
      ),
    );
  }
}
