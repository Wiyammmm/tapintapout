import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';

class PermissionController extends GetxController {
  var locationPermission = Rx<LocationPermission?>(null);
  // var bluetooth = BlueThermalPrinter.instance.obs;
  var storagePermission = Rx<PermissionStatus>(PermissionStatus.denied);
  var isPrinter = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
    checkStoragePermission();
    isSunmiPrinterBind();
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

  Future<void> isSunmiPrinterBind() async {
    print('isSunmiPrinterBind model: ${deviceInfoService.deviceModel.value}');
    if (deviceInfoService.deviceModel.value == "V2s_STGL") {
      isPrinter.value = await SunmiPrinter.bindingPrinter() ?? false;
    } else {
      final telpoFlutterChannel = TelpoFlutterChannel();
      isPrinter.value = await telpoFlutterChannel.connect();
      final TelpoStatus status = await telpoFlutterChannel.checkStatus();
      print('telpo connect: ${isPrinter.value}');
      print('telpo status: $status');
    }

    print('isPrinter: ${isPrinter.value}');
  }
}
