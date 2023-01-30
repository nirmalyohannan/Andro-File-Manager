import 'package:flutter/material.dart';

Widget iconTile(
  BuildContext context, {
  required IconData iconData,
  required String title,
  required Function() onPressed,
  Color color = Colors.black,
}) {
  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
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
    ),
  );
}
