import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapintapout/backend/nfc.dart';
import 'package:tapintapout/backend/printer/printServices.dart';
import 'package:tapintapout/backend/printer/printerController.dart';
import 'package:tapintapout/backend/services/udp_services.dart';
import 'package:tapintapout/presentation/pages/settings.dart';
import 'package:tapintapout/presentation/pages/transactionPage.dart';
import 'package:tapintapout/presentation/widgets/base.dart';
import 'package:tapintapout/presentation/widgets/buttons.dart';
import 'package:tapintapout/presentation/widgets/dialogs.dart';

import '../../core/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PrinterController connectToPrinter = Get.put(PrinterController());
  NfcService nfcService = NfcService();

  // final UdpService udpService = Get.find<UdpService>();
  @override
  void initState() {
    _startLocation();
    _checkNfcAndStartSession();
    _connectToPrinter();
    _askPermission();
    if (!udpService.isConnected.value) {
      udpService.initializeUDP();
    }

    udpService.listenToMessages((String message) async {
      if (!mounted) return;
      print("New message received: $message");
      if (message.contains("uid:")) {
        RegExp uidRegex = RegExp(r'uid:([A-F0-9]+)');
        var uidMatch = uidRegex.firstMatch(message);
        if (uidMatch != null) {
          String uid = uidMatch.group(1)!;
          print('UID: $uid');
          _processTransactionResponse(uid);

          // _transactionProcess(uid);
        }
      } else {
        print("No UID found in the string.");
      }
    });
    super.initState();
  }

  void _startLocation() async {
    await deviceInfoService.startGeolocatorTracking();
  }

  void _processTransactionResponse(String uid) async {
    Map<String, dynamic> processTransactionResponse =
        await processServices.transactionProcess(uid, context);
    print('processTransactionResponse: $processTransactionResponse');
  }

  @override
  void dispose() {
    flutterTts.stop(); // Ensure TTS is stopped when the widget is disposed
    super.dispose();
  }

  void _askPermission() async {
    await Permission.location.request();
    await Permission.storage.request();
  }

  void _connectToPrinter() async {
    try {
      final resultprinter = await connectToPrinter.connectToPrinter();

      if (resultprinter != null) {
        print('resultprinter: $resultprinter');
        if (resultprinter) {
        } else {
          ArtDialogResponse response = await ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.danger,
                  title: "Can't connect to printer",
                  text: "Open Bluetooth to automatically connect"));
          print('response: $response');
          if (response.isTapConfirmButton) {
            // _connectToPrinter();
          }
        }
      } else {
        ArtDialogResponse response = await ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Can't connect to printer",
                text: "Open Bluetooth to automatically connect"));
        print('else resultprinter: $resultprinter');
        print('response: $response');
        if (response.isTapConfirmButton) {
          // _connectToPrinter();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _checkNfcAndStartSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      // Start NFC session
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          String tagId = nfcService.extractTagId(tag);
          print('tagid: $tagId');
          // _transactionProcess(tagId);
          _processTransactionResponse(tagId);
        },
      );
    } else {
      print('NFC is not available on this device.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _checkNfcAndStartSession(),
      child: WillPopScope(
        onWillPop: () async {
          // Return false to prevent the back button action
          return false;
        },
        child: BasePage(child: Obx(() {
          return Column(
            children: [
              AppBarWidget(context: context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              udpService.tps530IP.value == ""
                                  ? 'Disconnected: '
                                  : 'Connected:  ',
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: udpService.tps530IP.value == ""
                                      ? Colors.red
                                      : Colors.green),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Route: ${routeController.selectedRoute.value?.origin}-${routeController.selectedRoute.value?.destination}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/filipaycircle.png',
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/filipaywoman.png',
                              width: 70,
                            ),
                            const Text(
                              'TAP YOUR NFC CARD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const circleButton(
                              thisIcon: Icon(
                                Icons.qr_code,
                                size: 40,
                              ),
                            ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            // const circleButton(
                            //   thisIcon: Icon(
                            //     Icons.refresh,
                            //     size: 40,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TransactionPage()),
                                );
                              },
                              child: const circleButton(
                                thisIcon: Icon(
                                  Icons.file_present_outlined,
                                  size: 40,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()),
                                );
                              },
                              child: const circleButton(
                                thisIcon: Icon(
                                  Icons.settings,
                                  size: 40,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        })),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.lightBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${tapinController.tapin.length}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Pass\nCount',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
          FittedBox(
            child: Text(
              printServices.breakString(
                  '${coopInfoController.coopInfo.value?.cooperativeName}', 24),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          IconButton(
              onPressed: () => DialogUtils.showLogout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 40,
              ))
        ],
      ),
    );
  }
}
