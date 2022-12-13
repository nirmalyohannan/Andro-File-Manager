import 'package:androfilemanager/functions/authentication.dart';
import 'package:androfilemanager/functions/open_dir.dart';
import 'package:androfilemanager/pages/settings_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:androfilemanager/widgets/diskspace_tile.dart';
import 'package:androfilemanager/widgets/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/icon_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                        children: [
                          IconButton(
                            icon: const Icon(Icons.settings),
                            iconSize: 40,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingScreen(),
                                  ));
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          // 'assets/logo/AndroFileManagerLogo.png',
                          // 'assets/logo/AndroFilesLogo.png',
                          'assets/logo/AndroLogo.png',
                          width: MediaQuery.of(context).size.width / 1.7,
                        ),
                      ),
                      //:::::::::::Videos,Pictures,Musics,Downloads etc....Section::::::::::::
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 231, 235, 242),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          padding: const EdgeInsets.all(10),
                          children: <Widget>[
                            iconTile(context,
                                iconData: Icons.video_file_outlined,
                                title: 'Videos',
                                location: '/storage/emulated/0/Movies'),
                            iconTile(context,
                                iconData: Icons.image_outlined,
                                title: 'Pictures',
                                location: '/storage/emulated/0/Pictures'),
                            iconTile(context,
                                iconData: Icons.music_note_outlined,
                                title: 'Musics',
                                location: '/storage/emulated/0/Music'),
                            iconTile(context,
                                iconData: Icons.download,
                                title: 'Downloads',
                                location: '/storage/emulated/0/Download'),
                            iconTile(context,
                                iconData: Icons.file_copy,
                                title: 'Documents',
                                location: '/storage/emulated/0/Documents'),
                            iconTile(context,
                                iconData: Icons.android,
                                title: 'Apps',
                                location: '/storage/emulated/0/Download'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //:::::::::Disk Space Section::::::::
              const SizedBox(height: 10),
              diskSpaceTile(context),
              diskSpaceTile(context, isInternalStorage: false),
              tileButton(
                icon: Icons.lock,
                title: 'Protected Files',
                onPressed: () async {
                  if (await authenticate()) {
                    openDir(context,
                        location: await getApplicationDocumentsDirectory()
                            .then((value) => value.path));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
