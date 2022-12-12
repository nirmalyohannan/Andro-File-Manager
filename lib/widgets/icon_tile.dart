import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';

import '../functions/open_dir.dart';

Widget iconTile(
  BuildContext context, {
  required IconData iconData,
  required String title,
  required String location,
  Color color = Colors.black54,
}) {
  return GestureDetector(
    onTap: () {
      openDir(context, location: location);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 60,
          color: color,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    ),
  );
}
