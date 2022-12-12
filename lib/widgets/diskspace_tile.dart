import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/functions/format_file_size.dart';
import 'package:androfilemanager/pages/file_explorer_screen.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../main.dart';

Widget diskSpaceTile(BuildContext context, {bool isInternalStorage = true}) {
  String location;
  String title;
  Icon icon;

  Future<double> totalGB;
  Future<double> freeGB;

  if (isInternalStorage) {
    location = internalRootDir;
    title = 'Internal Storage';
    icon = const Icon(
      Icons.storage,
      size: 50,
    );
    totalGB =
        diskSpace.totalInternalBytes().then((value) => formatFileSizeGB(value));
    freeGB =
        diskSpace.freeInternalBytes().then((value) => formatFileSizeGB(value));
  } else if (externalStorageExists) {
    location = externalRootDir!;
    title = 'External Storage';
    icon = const Icon(
      Icons.sd_card,
      size: 50,
    );
    totalGB =
        diskSpace.totalExternalBytes().then((value) => formatFileSizeGB(value));
    freeGB =
        diskSpace.freeExternalBytes().then((value) => formatFileSizeGB(value));
  } else {
    return const Text("No External Storage");
  }
  return InkWell(
    splashColor: primaryColor.value,
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return FileExplorerScreen(
            location: location,
          );
        },
      ));
    },
    child: ValueListenableBuilder(
      valueListenable: primaryColor,
      builder: (context, mainColor, child) => Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            FutureBuilder(
                future: Future.wait([freeGB, totalGB]),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return const SizedBox(
                      width: double.maxFinite,
                      child: LinearProgressIndicator(),
                    );
                  } else {
                    return SizedBox(
                      height: 53,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          LinearPercentIndicator(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            barRadius: const Radius.circular(10),
                            percent:
                                1 - (snapshot.data![0] / snapshot.data![1]),
                            lineHeight: 10,
                            width: MediaQuery.of(context).size.width - 100,
                            backgroundColor: Color.fromARGB(150, 19, 31, 140),
                            progressColor: Color.fromARGB(255, 19, 31, 140),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: Row(
                              //why not Row taking full width?
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${snapshot.data![0]} GB Free of ${snapshot.data![1]} GB'),
                                Text(
                                    '${(100 - (snapshot.data![0] * 100 / snapshot.data![1])).toStringAsFixed(2)}% used'),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    ),
  );
}
