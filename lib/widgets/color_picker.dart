import 'package:androfilemanager/consts.dart';
import 'package:androfilemanager/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:ms_material_color/ms_material_color.dart';
import 'package:ncscolor/ncscolor.dart';

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
                colorBox(androPrimeColor),
                colorBox(Colors.deepPurpleAccent),
                colorBox(Colors.deepPurple),
                colorBox(Colors.yellowAccent),
                colorBox(Colors.amber),
                colorBox(Colors.redAccent),
                colorBox(Colors.green),
                colorBox(Colors.lightGreen),
                colorBox(Colors.lime)
              ]),
        ),
      );
    },
  );
}

Widget colorBox(Color color) {
  return GestureDetector(
    onTap: () async {
      String colorHex =
          ColorConvert.rgbToHex(r: color.red, b: color.blue, g: color.green);
      colorHex = '0xFF${colorHex.replaceAll('#', '')}';

      primaryColor.value = MsMaterialColor(int.parse(colorHex));
      primaryColor.notifyListeners();
      await appThemeBox.put('colorRed', primaryColor.value.red);
      await appThemeBox.put('colorGreen', primaryColor.value.green);
      await appThemeBox.put('colorBlue', primaryColor.value.blue);
    },
    child: Container(
      decoration: BoxDecoration(color: color),
    ),
  );
}
