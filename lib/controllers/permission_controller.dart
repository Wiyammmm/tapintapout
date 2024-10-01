import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var locationPermission = Rx<LocationPermission?>(null);
  var bluetooth = BlueThermalPrinter.instance.obs;
  var storagePermission = Rx<PermissionStatus>(PermissionStatus.denied);
  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
    checkStoragePermission();
  }

  Future<void> checkLocationPermission() async {
    locationPermission.value = await Geolocator.checkPermission();
    print('locationPermission.value: ${locationPermission.value}');
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    locationPermission.value = permission; // Update the observable value
  }

  Future<void> checkStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    storagePermission.value = status; // Update the observable value
  }

  Future<void> requestStoragePermission() async {
    storagePermission.value = await Permission.storage.request();
  }
}
