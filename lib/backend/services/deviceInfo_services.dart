import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:simnumber/sim_number.dart';

import 'package:simnumber/siminfo.dart';
import 'package:sunmi_scanner/sunmi_scanner.dart';
import 'package:tapintapout/core/sweetalert.dart';
// import 'package:location/location.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/transaction_model.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService extends GetxService {
  static const platform = const MethodChannel("com.flutter.epic/epic");
  late LocationSettings locationSettings;
  StreamSubscription<Position>? positionStream;
  var transactionResponse = "".obs;
  // Location location = Location();
  // StreamSubscription<LocationData>? locationSubscription;
  bool isfetchingFilipayCard = false;
  bool isSendingTransaction = false;
  var deviceModel = "".obs;
  var lat = ''.obs;
  var long = ''.obs;
  var isSunmiScanner = false.obs;
  late StreamSubscription<String> barcodeSubscription;
  var serialNumber = "".obs;
  Future<void> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceModel.value = androidInfo.model.toString();
    print('deviceModel.value: ${deviceModel.value}');
  }

  Future<void> getDeviceSerialNumber() async {
    // String? identifier;
    String value = '';
    // Map<String, dynamic> allInfo = {};
    try {
      // final status = await Permission.phone.request();
      // if (status.isGranted) {
      value = await platform.invokeMethod("Printy");

//         identifier = await UniqueIdentifier.serial;
// //      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         print('identifier serial#: $identifier');
//         final deviceInfoPlugin = DeviceInfoPlugin();
//         final deviceInfo = await deviceInfoPlugin.deviceInfo;
//         allInfo = deviceInfo.data;

//         print('allInfo: $allInfo');
//         print(deviceInfo.data['serialNumber']);
      // }
    } catch (e) {
      // Handle errors or exceptions here
      print('Error getting device information: $e');
    }
    serialNumber.value = value;
    print('serialNumber.value: $serialNumber');
  }

  Future<String> getMobileNumber() async {
    String mobileNumber = "";
    try {
      SimInfo simInfo = await SimNumber.getSimData();
      for (var s in simInfo.cards) {
        print('mobile number: ${s.slotIndex} ${s.phoneNumber}');
        mobileNumber = "${s.phoneNumber}";
      }
    } catch (e) {
      print('error mobile number: $e');
    }

    return mobileNumber;
  }

  Future<void> startGeolocatorTracking() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 5),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "FILIPAY",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
      // bool _serviceEnabled;
      // PermissionStatus _permissionGranted;
      // LocationData _locationData;
      // LocationAccuracy _locationAccuracy;

      // _serviceEnabled = await location.serviceEnabled();
      // if (!_serviceEnabled) {
      //   _serviceEnabled = await location.requestService();
      //   if (!_serviceEnabled) {
      //     return;
      //   }
      // }

      // _permissionGranted = await location.hasPermission();
      // if (_permissionGranted == PermissionStatus.denied) {
      //   _permissionGranted = await location.requestPermission();
      //   if (_permissionGranted != PermissionStatus.granted) {
      //     return;
      //   }
      // }
      // await location.enableBackgroundMode(enable: true);
      // Position position = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.best);
      StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) async {
        print(position == null
            ? 'Unknown'
            : '${position.latitude.toString()}, ${position.longitude.toString()}');

        List<TransactionModel> transactionList =
            await hiveService.getTransaction();
        // Use current location
        // if (!isfetchingFilipayCard) {
        //   isfetchingFilipayCard = true;
        //    dataController.updateFilipayCard();
        //   isfetchingFilipayCard = false;
        // }
        if (transactionList.isNotEmpty) {
          transactionResponse.value = "";
          print('transactionResponse.value: ${transactionResponse.value}');
          print('transaction not empty');
          if (!isSendingTransaction) {
            isSendingTransaction = true;

            for (var element in List.from(transactionList)) {
              print('transaction element: $element');
              Map<String, dynamic> item = {
                "coopId": "${coopInfoController.coopInfo.value!.id}",
                "cardId": '${element.cardId}',
                "tapOutLat": "${element.tapOutLat}",
                "tapOutLong": "${element.tapOutLong}",
                "tapInLat": "${element.tapInLat}",
                "tapInLong": "${element.tapInLong}",
                "tapInStation": "${element.tapInStation}",
                "tapOutStation": "${element.tapOutStation}",
                "km_run": element.km_run,
                "amount": element.amount,
                "discount": element.discount,
                "fare": element.fare,
                "cardType": "${element.cardType}",
                "mop": "${element.mop}",
                "status": '${element.status}',
                "maxfare": element.maxfare,
                "ticketNumber": "${element.ticketNumber}",
                "vehicleNo": "${element.vehicleNo}",
                // "plateNumber": "${element.plateNumber}",
                "routeId": "${element.routeId}",
                "driverId": "${element.driverId}",
                "date": "${element.date}"
              };
              final sendTransactionResponse =
                  await dataController.sendTransaction(item);
              if (sendTransactionResponse['messages']['code'] == 0) {
                // isfetchingFilipayCard = false;
                dataController.updateFilipayCard();
                await hiveService.removeTransactionFromHive(
                    element.ticketNumber, element.status);
                transactionResponse.value = "";
              } else {
                transactionResponse.value =
                    "${sendTransactionResponse['messages']['message']} at TicketNo: ${element.ticketNumber}";
              }
              print('element item: $item');
              print('transactionResponse.value: ${transactionResponse.value}');
            }
            isSendingTransaction = false;
          }
        } else {
          print('transaction empty');
        }

        print('currentLocation accuracy: ${position?.accuracy}');
        print('currentLocation latitude: ${position?.latitude}');
        print('currentLocation longitude: ${position?.longitude}');
        print('currentLocation speedAccuracy: ${position?.speedAccuracy}');

        lat.value = position!.latitude.toString();
        long.value = position!.longitude.toString();
        lat.refresh();
        long.refresh();

        await processServices.updateTargetStationId(lat.value, long.value);
        print('lat.value: ${lat.value}');
        print('long.value: ${long.value}');
      });
      // locationSubscription = location.onLocationChanged
      //     .listen((LocationData currentLocation) async {

      // });
    } catch (e) {
      print('error start location: $e');
      startGeolocatorTracking();
    }
  }

  Future<void> stopLocation() async {
    positionStream?.cancel();
    positionStream = null;
  }

  Future<void> getIfSunmiScanner() async {
    isSunmiScanner.value = await SunmiScanner.isScannerAvailable();
    if (isSunmiScanner.value) {
      sunmiScannerListener();
    }
  }

  Future<void> turnoffSunmiScanner() async {
    if (isSunmiScanner.value) {
      SunmiScanner.stop();
      barcodeSubscription.cancel();
      isSunmiScanner.value = false;
    }
  }

  void sunmiScannerListener() async {
    if (isSunmiScanner.value) {
      barcodeSubscription = SunmiScanner.onBarcodeScanned().listen((event) {
        print('code: $event');
        if (Navigator.canPop(Get.context!)) {
          print('navigator pop?');

          Navigator.pop(Get.context!);
          print('navigator yes pop');
        }
        SweetAlertUtils.showInformationDialog(Get.context!,
            title: 'Code', thisTitle: 'value: $event', onConfirm: () {
          Navigator.of(Get.context!).pop();
        });
      });
    }
  }
}
