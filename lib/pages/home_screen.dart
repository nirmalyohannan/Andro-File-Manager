import 'dart:developer';

import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/authentication.dart';
import 'package:androfilemanager/functions/open_dir.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/pages/recent_files_screen.dart';
import 'package:androfilemanager/pages/settings_screen.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/widgets/diskspace_tile.dart';
import 'package:androfilemanager/widgets/tile_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../widgets/icon_tile.dart';
import 'file_type_screen.dart';

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
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            //Drag Down to open Recent Files
            log(details.delta.dy.toString());
            if (details.delta.dy > 5) {
              Navigator.push(context, routeRecentFiles());
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Consumer<ColorThemes>(
                  builder: (context, colorThemes, child) => Container(
                    decoration: BoxDecoration(
                        color: colorThemes.primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LottieBuilder.asset(
                                  "assets/lottie/swipe_down.json",
                                  height: 60,
                                ),
                                const Text(
                                  "Recent Files(Swipe Down)",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingScreen(),
                                    ));
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            child: Image.asset(
                              // 'assets/logo/AndroFileManagerLogo.png',
                              // 'assets/logo/AndroFilesLogo.png',
                              'assets/logo/AndroLogo.png',

                              // width: MediaQuery.of(context).size.width / 1.7,
                            ),
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
                              iconTile(
                                context,
                                iconData: Icons.video_file_outlined,
                                title: 'Videos',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return FileTypeScreen(
                                        directoryTitle: "Videos",
                                        typesList: videoTypes,
                                      );
                                    },
                                  ));
                                },
                              ),
                              iconTile(context,
                                  iconData: Icons.image_outlined,
                                  title: 'Pictures', onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FileTypeScreen(
                                      directoryTitle: "Images",
                                      typesList: imageTypes,
                                    );
                                  },
                                ));
                              }),
                              iconTile(
                                context,
                                iconData: Icons.music_note_outlined,
                                title: 'Musics',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return FileTypeScreen(
                                        directoryTitle: "Music",
                                        typesList: audioTypes,
                                      );
                                    },
                                  ));
                                },
                              ),
                              iconTile(context,
                                  iconData: Icons.download,
                                  title: 'Downloads', onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FileExplorerScreen(
                                      location: '${internalRootDir}Download',
                                    );
                                  },
                                ));
                              }),
                              iconTile(context,
                                  iconData: Icons.file_copy,
                                  title: 'Documents', onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return FileTypeScreen(
                                      directoryTitle: "Documents",
                                      typesList: documentTypes,
                                    );
                                  },
                                ));
                              }),
                              iconTile(
                                context,
                                iconData: Icons.android,
                                title: 'Apps',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return FileTypeScreen(
                                        directoryTitle: "App apks",
                                        typesList: appTypes,
                                      );
                                    },
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    openDir(context, location: protectedDir.path);
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

Route routeRecentFiles() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const RecentFilesScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.slowMiddle;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
