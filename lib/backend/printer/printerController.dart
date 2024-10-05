import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';

class PrinterController extends GetxService {
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  var connected = false.obs;
  // Future<bool> connectToPrinter() async {
  //   BluetoothDevice? targetDevice;
  //   try {
  //     List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
  //     print(devices);
  //     for (BluetoothDevice device in devices) {
  //       print('device.address: ${device.address}');
  //       if (device.address == '00:11:22:33:44:55' ||
  //           device.name == 'InnerPrinter') {
  //         targetDevice = device;
  //         break;
  //       }
  //     }
  //     if (targetDevice != null) {
  //       connected.value = true;
  //     } else {
  //       bluetooth.onStateChanged().listen((state) {
  //         switch (state) {
  //           case BlueThermalPrinter.CONNECTED:
  //             connected.value = true;
  //             print("bluetooth device state: connected");
  //             break;
  //           case BlueThermalPrinter.DISCONNECTED:
  //             connected.value = false;
  //             print("bluetooth device state: disconnected");
  //             break;
  //           case BlueThermalPrinter.DISCONNECT_REQUESTED:
  //             connected.value = false;
  //             print("bluetooth device state: disconnect requested");
  //             break;
  //           case BlueThermalPrinter.STATE_TURNING_OFF:
  //             connected.value = false;
  //             print("bluetooth device state: bluetooth turning off");
  //             break;
  //           case BlueThermalPrinter.STATE_OFF:
  //             connected.value = false;
  //             print("bluetooth device state: bluetooth off");
  //             break;
  //           case BlueThermalPrinter.STATE_ON:
  //             connected.value = false;

  //             print("bluetooth device state: bluetooth on");
  //             break;
  //           case BlueThermalPrinter.STATE_TURNING_ON:
  //             connected.value = false;
  //             print("bluetooth device state: bluetooth turning on");
  //             break;
  //           case BlueThermalPrinter.ERROR:
  //             connected.value = false;
  //             print("bluetooth device state: error");
  //             break;
  //           default:
  //             print(state);
  //             break;
  //         }
  //       });
  //     }

  //     // Find the printer with the specified MAC address or name

  //     if (targetDevice != null) {
  //       print('targetDevice: $targetDevice');
  //       bool isConnected = await bluetooth.isConnected ?? false;
  //       if (!isConnected) {
  //         await bluetooth.connect(targetDevice).catchError((error) {
  //           connected.value = false;
  //         });
  //         connected.value = true;
  //       }
  //       return connected.value;
  //     } else {
  //       print('Printer not found or not paired.');
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  //   // Retrieve the list of bonded (paired) devices
  // }

  // void disconnectFromPrinter() {
  //   if (connected.value) {
  //     bluetooth.disconnect();
  //     connected.value = false;
  //   }
  // }

  // Add a function for printing if needed
  void printReceipt() {
    // Your printing logic here
  }

  Future<bool> isTelpoPrintProceed() async {
    final telpoFlutterChannel = TelpoFlutterChannel();
    final bool? isConnected = await telpoFlutterChannel.isConnected();
    final TelpoStatus status = await telpoFlutterChannel.checkStatus();
    if (isConnected != null) {
      if (status == TelpoStatus.ok && isConnected) {
        permissionController.isPrinter.value = true;
        return true;
      }
    }
    permissionController.isPrinter.value = false;
    return false;
  }
}

// void main() async {
//   final printerController = PrinterController();
//   await printerController.connectToPrinter();

//   if (printerController.connected.value) {
//     // Use the printer for printing
//     printerController.printReceipt();
//   }

//   // Don't forget to disconnect when done
//   printerController.disconnectFromPrinter();
// }
