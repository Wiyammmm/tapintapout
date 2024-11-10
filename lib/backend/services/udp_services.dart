import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:udp/udp.dart';

class UdpService extends GetxService {
  int tps530Port = 1515;
  int myPort = 1212;
  Rx<UDP?> sender = Rx<UDP?>(null);
  var messageReceived = ''.obs;
  var isConnected = false.obs;
  int flag = 0;
  var tps530IP = "".obs;
  RxList<String> messages = <String>[].obs;
  // Initialize UDP receiver and sender

  String extractIp(String input) {
    RegExp ipRegex = RegExp(r'ip:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)');

    // Match the UID and IP

    var ipMatch = ipRegex.firstMatch(input);
    String ip = ipMatch!.group(1)!; // Get the IP value

    print('IP: $ip');

    return ip;
  }

  void checkifClose(String input) {
    // Regular expression to match 'close' and 'ip'
    RegExp regex =
        RegExp(r'close:(true|false),ip:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)');

    // Match the pattern
    var match = regex.firstMatch(input);

    if (match != null) {
      // Extract the close status and IP address
      String closeStatus = match.group(1)!; // true or false
      String ip = match.group(2)!; // IP address

      print('close: $closeStatus');
      print('ip: $ip');
      tps530IP.value = "";
      processServices.speak('Disconnected tps530!');
    } else {
      // Handle case when 'close' and 'ip' are not found
      print('No match found');
    }
  }

  Future<void> initializeUDP() async {
    print('initializeUDP run');
    try {
      sender.value = await UDP.bind(Endpoint.any(port: Port(myPort)));

      isConnected.value = true;

      sender.value?.asStream().listen((datagram) {
        if (datagram != null) {
          var str = String.fromCharCodes(datagram.data);
          messageReceived.value = "$flag$str";
          print('message received: ${messageReceived.value}');
          // messages.add("$flag$str");
          messages.add("${messages.length}. Received from tps530");
          tps530IP.value = extractIp(str);
          checkifClose(str);
          ever(tps530IP, (newValue) {
            if (newValue != "") {
              processServices.speak('Connected tps530!');
            }
            print('changed $newValue');
          });
          flag++;
        }
      }, onDone: () {
        print("Stream ended unexpectedly");
        isConnected.value = false;
      }, onError: (error) {
        print("Error receiving data: $error");
        isConnected.value = false;
      });

      print("UDP Receiver started successfully.");
    } catch (e) {
      print("Error initializing UDP: $e");
      isConnected.value = false;
    }
  }

  // Send a message
  Future<void> sendMessage(String message) async {
    if (tps530IP.value != "") {
      if (sender != null) {
        var dataLength = await sender.value?.send(
            message.codeUnits,
            Endpoint.unicast(
              InternetAddress(tps530IP.value),
              port: Port(tps530Port),
            ));
        print("$dataLength bytes senttt.");
      } else {
        print("Sender not initialized.");
      }
    }
  }

  // Close UDP connections
  Future<void> closeUDP() async {
    await sendMessage('close:true');
    sender.value?.close();
    isConnected.value = false;
    tps530IP.value = "";
    messages.clear();
  }

  // Check if connected
  bool isReceiverConnected() {
    return isConnected.value;
  }

  void listenToMessages(Function(String) onMessage) {
    print('listenToMessages running');

    ever(messageReceived, (String message) {
      onMessage(message); // Call the function when messageReceived changes
    });
  }
}
