import 'package:androfilemanager/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget tileButton(
    {required IconData icon, required String title, Function()? onPressed}) {
  return InkWell(
    onTap: onPressed ?? () {},
    child: Consumer<ColorThemes>(
      builder: (context, colorThemes, child) => Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: colorThemes.primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Icon(
              icon,
              size: 60,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    ),
  );
}
