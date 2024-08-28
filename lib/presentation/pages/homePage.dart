import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:tapintapout/backend/nfc.dart';
import 'package:tapintapout/backend/printer/printServices.dart';
import 'package:tapintapout/backend/printer/printerController.dart';
import 'package:tapintapout/presentation/widgets/base.dart';
import 'package:tapintapout/presentation/widgets/buttons.dart';
import 'package:tapintapout/presentation/widgets/dialogs.dart';

import '../../core/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.thisTitle});
  final String thisTitle;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PrinterController connectToPrinter = PrinterController();
  NfcService nfcService = NfcService();
  List<Map<String, dynamic>> tags = [];
  List<String> transactions = [];
  @override
  void initState() {
    _checkNfcAndStartSession();
    _connectToPrinter();
    myBox.put('tags', tags);
    myBox.put('transactions', tags);
    // tags = myBox.get('tags');

    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop(); // Ensure TTS is stopped when the widget is disposed
    super.dispose();
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

  Future _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _addTransction(String tagId, String ticketNumber) async {
    Map<String, dynamic> addTransactionResponse =
        await apiServices.addTransaction({
      "coopId": "6569bf3b691671079b8324da",
      "cardId": tagId,
      "tapOutLat": "14.000",
      "tapOutLong": "14.000",
      "tapInLat": "14.000",
      "tapInLong": "14.000",
      "tapInStation": "Station 1",
      "tapOutStation": "Station 2",
      "km_run": 0,
      "amount": 30,
      "discount": 0,
      "fare": 30,
      "cardType": 'regular',
      "mop": 'filipaycard',
      "status": "tapin",
      "maxfare": 30,
      "ticketNumber": ticketNumber
    });
    if (addTransactionResponse['messages']['code'] == 0) {
      String text = "Tap-in Successfully!";
      _speak(text);
      DialogUtils.showTapin(context);
    } else {
      String text = "${addTransactionResponse['messages']['message']}";
      _speak(text);
      ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            title: 'Something went wrong',
            text: '${addTransactionResponse['messages']['message']}',
            type: ArtSweetAlertType.danger,
          ));
    }
  }

  void _updateTransction(String tagId, String ticketNumber) async {
    Map<String, dynamic> addTransactionResponse =
        await apiServices.updateTransaction({
      "coopId": "6569bf3b691671079b8324da",
      "cardId": tagId,
      "tapOutLat": "14.000",
      "tapOutLong": "14.000",
      "tapInLat": "14.000",
      "tapInLong": "14.000",
      "tapInStation": "Station 1",
      "tapOutStation": "Station 2",
      "km_run": 3,
      "amount": 13,
      "discount": 0,
      "fare": 13,
      "cardType": 'regular',
      "mop": 'filipaycard',
      "status": "tapout",
      "maxfare": 30,
      "ticketNumber": ticketNumber
    });
    if (addTransactionResponse['messages']['code'] == 0) {
      myBox.put('transactions', transactions);
      myBox.put('tags', tags);
      String text = "Tap-out Successfully!";
      _speak(text);
      DialogUtils.showTapout(
          context,
          double.parse(
              "${addTransactionResponse['response']['balance']['newBalance']}"));
      printServices.printTransactionReceipt(addTransactionResponse['response']);
    } else {
      String text = "${addTransactionResponse['messages']['message']}";
      _speak(text);
      ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            title: 'Something went wrong',
            text: '${addTransactionResponse['messages']['message']}',
            type: ArtSweetAlertType.danger,
          ));
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
          if (tags.isNotEmpty) {
            if (tags.any((item) => item['cardId'] == tagId)) {
              Map<String, dynamic> item =
                  tags.firstWhere((item) => item['cardId'] == tagId);
              // Retrieve the name from the found map
              String ticketNumber = item['ticketNumber'];
              tags.removeWhere((item) => item['cardId'] == tagId);
              setState(() {
                transactions.add(tagId);
              });

              _updateTransction(tagId, ticketNumber);
            } else {
              String ticketNumber = generatorServices.generateTicketNo();
              _addTransction(tagId, ticketNumber);
              tags.add({"cardId": tagId, "ticketNumber": ticketNumber});
            }
          } else {
            String ticketNumber = generatorServices.generateTicketNo();
            _addTransction(tagId, ticketNumber);
            tags.add({"cardId": tagId, "ticketNumber": ticketNumber});
          }
          print('tags: $tags');
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
        child: BasePage(
            child: Column(
          children: [
            myAppBar(context),
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
                      child: Text(
                        'Route: ${widget.thisTitle}',
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circleButton(
                            thisIcon: Icon(
                              Icons.qr_code,
                              size: 40,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          circleButton(
                            thisIcon: Icon(
                              Icons.refresh,
                              size: 40,
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
        )),
      ),
    );
  }

  Container myAppBar(BuildContext context) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${transactions.length}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Pass\nCount',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
          ),
          const FittedBox(
            child: Text(
              'SERVICE ECONOMY\nAPPLICATION INC.',
              textAlign: TextAlign.center,
              style: TextStyle(
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
