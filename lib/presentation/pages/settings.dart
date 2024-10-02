import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:tapintapout/backend/printer/printerController.dart';
import 'package:tapintapout/backend/services/udp_services.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/station_model.dart';
import 'package:tapintapout/presentation/pages/unsycPage.dart';
import 'package:udp/udp.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PrinterController printerController = Get.put(PrinterController());

  UDP? sender;
  bool isConnected = false;

  int tps530Port = 1515;
  int myPort = 1212;
  String tps530IP = "";

  final UdpService udpService = Get.find<UdpService>();
  Future<void> _getIp() async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    print("wifiIP: $wifiIP");
  }

  String extractIp(String input) {
    RegExp ipRegex = RegExp(r'ip:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)');

    // Match the UID and IP

    var ipMatch = ipRegex.firstMatch(input);
    String ip = ipMatch!.group(1)!; // Get the IP value

    print('IP: $ip');

    return ip;
  }

  Future<void> connectUDP() async {
    try {
      _getIp();
      await udpService.initializeUDP();
    } catch (e) {
      print("Error setting up UDP: $e");
    }
  }

  // Send a message
  Future<void> sendMessage(String message) async {
    udpService.sendMessage(message);
    if (mounted) {
      udpService.messages.add('sent: $message');
    }
  }

  Future<void> closeUDP() async {
    udpService.closeUDP();
    // setState(() {
    //   _messages.clear();
    //   udpService.isConnected.value = false;
    //   isConnected = false;
    // });
    // sender?.close();
  }

  void _listenMessages() {
    udpService.listenToMessages((String message) {
      if (mounted) {
        udpService.messages.add('received: $message');
        print("New message received: $message");
      }
    });
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
  }

  @override
  void initState() {
    // isConnected = udpService.isReceiverConnected();
    // if (isConnected) {
    //   sender = udpService.sender.value;
    //   _listenMessages();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(child: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [],
              ),
              Text('Data'),
              ElevatedButton(
                  onPressed: () {
                    SweetAlertUtils.showConfirmationDialog(context,
                        onConfirm: () {
                      Navigator.of(context).pop();
                      dialogUtils.showFetchingDataDialog(context);
                    }, thisTitle: 'Do you want to re-fetch the data?');
                  },
                  child: Text('Re-fetch data')),

              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UnsyncPage()),
                    );
                  },
                  child: Text('Sync Data')),
              // ElevatedButton(
              //     onPressed: () async {
              //       await getDataServices.getSelectedVehicleInfo();
              //     },
              //     child: Text('test')),

              Divider(),
              Text(
                  'Printer Status: ${printerController.connected.value ? 'Connected' : 'Disconnected'}'),
              ElevatedButton(
                  onPressed: () {
                    printerController.connected.value
                        ? printerController.disconnectFromPrinter()
                        : printerController.connectToPrinter();
                  },
                  child: Text(printerController.connected.value
                      ? 'Disconnect to Printer'
                      : 'Connect to Printer')),
              // if (printerController.connected.value)
              ElevatedButton(
                  onPressed: () {
                    printServices.sample();
                  },
                  child: Text('Test Print')),
              Divider(),
              Text(
                  'UDP Status: ${udpService.isConnected.value ? 'Connected' : 'Disconnected'}'),
              Text(
                  'TPS 530 status: ${udpService.tps530IP.value == '' ? 'Disconnected' : 'Connected'}'),
              if (!udpService.isConnected.value)
                ElevatedButton(
                    onPressed: () {
                      connectUDP();
                    },
                    child: Text('Connect UDP')),
              if (udpService.isConnected.value) ...[
                if (udpService.tps530IP.value != '')
                  ElevatedButton(
                      onPressed: () {
                        sendMessage("hello from sunmi");
                      },
                      child: Text('Send Message')),
                ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> coopdata = {
                        "cooperativeName": "SERVICE ECONOMY APPLICATION INC.",
                        "cooperativeCodeName": "SEAPPS",
                      };

                      sendMessage("coopData: ${coopdata.toString()}");
                    },
                    child: Text('Send Data')),
                ElevatedButton(
                    onPressed: () {
                      closeUDP();
                    },
                    child: Text('Close UDP')),
                Expanded(
                  child: ListView.builder(
                    itemCount: udpService.messages.length,
                    itemBuilder: (context, index) {
                      var messages = udpService.messages.reversed.toList();
                      return ListTile(
                        title: Text(messages[index]),
                      );
                    },
                  ),
                )
              ]
            ],
          ),
        );
      })),
    );
  }
}
