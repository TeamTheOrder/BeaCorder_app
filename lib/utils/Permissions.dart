import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission() async {
  PermissionStatus location_status = await Permission.location.status;
  PermissionStatus scan_status = await Permission.bluetoothScan.status;

  if(location_status.isDenied) {
    await Permission.location.request();
  }

  if(scan_status.isDenied) {
    await Permission.bluetoothScan.request();
  }

}