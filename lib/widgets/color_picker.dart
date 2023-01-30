import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/states.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';
import 'package:provider/provider.dart';

Future<void> colorPicker(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Choose Color'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
              shrinkWrap: true,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 3,
              children: [
                colorBox(context, androPrimeColor),
                colorBox(context, Colors.deepPurpleAccent),
                colorBox(context, Colors.deepPurple),
                colorBox(context, Colors.yellowAccent),
                colorBox(context, Colors.amber),
                colorBox(context, Colors.redAccent),
                colorBox(context, Colors.green),
                colorBox(context, Colors.lightGreen),
                colorBox(context, Colors.lime)
              ]),
        ),
      );
    },
  );
}

Widget colorBox(BuildContext context, Color color) {
  return GestureDetector(
    onTap: () async {
      String colorHex =
          ColorConvert.rgbToHex(r: color.red, b: color.blue, g: color.green);
      colorHex = '0xFF${colorHex.replaceAll('#', '')}';

      MsMaterialColor tempColor = MsMaterialColor(int.parse(colorHex));
      context.read<ColorThemes>().primaryColor = tempColor;
      // primaryColor.value = MsMaterialColor(int.parse(colorHex));
      context.read<ColorThemes>().notify();
      await appConfigBox.put('colorRed', tempColor.red);
      await appConfigBox.put('colorGreen', tempColor.green);
      await appConfigBox.put('colorBlue', tempColor.blue);
    },
    child: Container(
      decoration: BoxDecoration(color: color),
    ),
  );
}
