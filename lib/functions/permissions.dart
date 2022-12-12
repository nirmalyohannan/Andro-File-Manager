import 'package:permission_handler/permission_handler.dart';

checkPermissions() async {
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}
