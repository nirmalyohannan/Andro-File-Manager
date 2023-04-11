import 'package:androfilemanager/functions/android_os.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissions() async {
  if (await getAndroidVersionInt() < 29) {
    //If Android Verison is less than Android 10(API: 29)
    //Storage permission is different for Android below Android 10 and Android above Android 11
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  } else {
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }
}
