import 'dart:math';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/filipaycard_model.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/station_model.dart';
import 'package:tapintapout/models/tapin_model.dart';
import 'package:tapintapout/models/transaction_model.dart';
import 'package:tapintapout/presentation/pages/unsycPage.dart';
import 'package:tapintapout/routes/app_pages.dart';

class ProcessServices {
  bool isDialogShow = false;
  Future speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<Map<String, dynamic>> transactionProcess(
      String tagid, BuildContext context) async {
    if (isDialogShow) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // This will close the dialog if it's open
      } else {
        print("No active dialog to close.");
      }
    }
    Map<String, dynamic> response = {
      'code': 1,
      'message': 'Something went wrong'
    };

    // try {
    List<FilipayCardModel> filipaycards = await hiveService.getFilipayCards();
    print('filipaycards:$filipaycards');

    if (filipaycards.any((card) => card.cardID == tagid)) {
      FilipayCardModel card =
          filipaycards.firstWhere((card) => card.cardID == tagid);

      print('tapinController.tapin: ${tapinController.tapin.value}');
      print('cardf  balance: ${card.balance}');
      print('cardf id: ${card.cardID}');
      print('cardf sn: ${card.sNo}');

      if (tapinController.tapin.any((element) =>
          (element.cardId == tagid && element.status == "tapin"))) {
        await tapoutProcess(tagid, response, context, card);
      } else {
        if (card.balance > routeController.selectedRoute.value!.maximumFare) {
          await tapinProcess(response, tagid, context);
        } else {
          response['message'] = 'Insufficient Balance';

          speak('Insufficient Balance!');
        }
      }
      dataController.updateFilipayCard();
    } else {
      response['message'] = 'Invalid Card';

      speak('Invalid Card!');
    }
    // } catch (e) {
    //   print('error transactionProcess: $e');
    //   response['code'] = 1;
    //   response['message'] = "Something went wrong";
    //   _speak('Something went wrong!');
    // }
    if (response['code'] != 0) {
      isDialogShow = true;
      ArtSweetAlert.show(
          context: context,
          barrierDismissible: true,
          artDialogArgs: ArtDialogArgs(
            title: '${response['message']}',
            text: 'Thank you',
            confirmButtonColor: Colors.blueAccent,
            type: response['code'] == 0
                ? ArtSweetAlertType.success
                : ArtSweetAlertType.warning,
          )).then((response) {
        isDialogShow = false;
        print("isDialogShow: $isDialogShow");
      });
      udpService.sendMessage('error:${response['message']}');
    }

    return response;
  }

  Future<void> tapoutProcess(String tagid, Map<String, dynamic> response,
      BuildContext context, FilipayCardModel card) async {
    isDialogShow = true;
    String destination = await getDataServices
        .getOrigin(sessionController.session.value!.lastStationId);

    hiveService.updateTapin(tagid, 'tapout', destination);
    response['code'] = 0;
    response['message'] = 'Tap-out Successfully';
    speak('Tap-out Successfully!');
  }

  Future<void> tapinProcess(
      Map<String, dynamic> response, String tagid, BuildContext context) async {
    response['code'] = 0;
    response['message'] = 'Tap-in Successfully';
    sessionController.printSession();
    speak('Tap-in Successfully!');

    String ticketNumber = generatorServices.generateTicketNo();
    String tapinStationid = sessionController.session.value!.lastStationId;
    String origin = await getDataServices.getOrigin(tapinStationid);

    TapinModel tapin = TapinModel(
        cardId: tagid,
        tapinStationId: tapinStationid,
        tapoutStationId: '',
        tapinLat: deviceInfoService.lat.value,
        tapinLong: deviceInfoService.long.value,
        tapoutLat: '',
        tapoutLong: '',
        status: 'tapin',
        ticketNumber: ticketNumber,
        origin: origin,
        destination: '',
        kmrun: 0,
        fare: double.parse(
            coopInfoController.coopInfo.value!.maximumFare.toString()),
        discount: 0,
        amount: double.parse(
            coopInfoController.coopInfo.value!.maximumFare.toString()),
        dateTime: getDataServices.getDateTime());

    String stationName = await getDataServices.getStationName(tapinStationid);
    print('tapin station: $stationName');
    TransactionModel transaction = TransactionModel(
        coopId: coopInfoController.coopInfo.value!.id,
        cardId: tagid,
        tapOutLat: " ",
        tapOutLong: " ",
        tapInLat: deviceInfoService.lat.value,
        tapInLong: deviceInfoService.long.value,
        tapInStation: stationName,
        tapOutStation: " ",
        km_run: 0,
        amount: double.parse(
            coopInfoController.coopInfo.value!.maximumFare.toString()),
        discount: 0,
        fare: double.parse(
            coopInfoController.coopInfo.value!.maximumFare.toString()),
        cardType: getDataServices.getCardType(tagid),
        mop: 'card',
        status: 'tapin',
        maxfare: double.parse(
            coopInfoController.coopInfo.value!.maximumFare.toString()),
        ticketNumber: ticketNumber);

    await hiveService.addTransaction(transaction);

    await hiveService.addTapin(tapin);
    isDialogShow = true;
    udpService.sendMessage(
        "tapin:{\'fare\':${double.parse(coopInfoController.coopInfo.value!.maximumFare.toString())}}");
    dialogUtils.showTapin(context, () {
      isDialogShow = false;
      print("isDialogShow: $isDialogShow");
    }, double.parse(coopInfoController.coopInfo.value!.maximumFare.toString()));
  }

  Future<void> updateTargetStationId(String lat, String long) async {
    Future<bool> isWithinRadius(double currentLat, double currentLong,
        double targetLat, double targetLong, double radiusInMeters) async {
      double distanceInMeters = Geolocator.distanceBetween(
          currentLat, currentLong, targetLat, targetLong);

      print('updateTargetStationId distanceInMeters: $distanceInMeters');
      return distanceInMeters <= radiusInMeters;
    }

    var box = await Hive.openBox<SessionModel>('session');
    if (box.isNotEmpty) {
      List<StationModel> stationList = await stationController
          .fetchStationsByRouteId(sessionController.session.value!.routeId);
      final oldTargetStationid = box.getAt(0)?.targetStationId;

      StationModel oldTargetStation = stationList.firstWhere(
        (station) => station.id == oldTargetStationid, // Condition: id equals 1
        orElse: () => throw Exception('Station not found'),
      );

      bool isNearby = await isWithinRadius(
          double.parse(lat),
          double.parse(long),
          oldTargetStation.lat,
          oldTargetStation.long,
          oldTargetStation.radius);
      if (isNearby) {
        final sessionBox = box.getAt(0);
        SessionModel session = SessionModel(
            routeId: sessionBox!.routeId,
            lastStationId: sessionBox.lastStationId,
            targetStationId: sessionBox.targetStationId,
            isReversed: sessionBox.isReversed);

        if (!routeController.selectedRoute.value!.routeLoop) {
          if (sessionBox.isReversed) {
            stationList = stationList.reversed.toList();
          }
        }
        for (var station in stationList) {
          print('new Station ID: ${station.id}');
          print('new Station Name: ${station.stationName}');
          print('new Station Number: ${station.stationNum}');
          print('new km: ${station.km}');
          print('new Latitude: ${station.lat}');
          print('new Longitude: ${station.long}');
          print('new  ---');
        }
        int index = stationList
            .indexWhere((station) => station.id == oldTargetStationid);
        print('current index: $index');

        if (stationList.length > index + 1) {
          print('greater than index');
          session.lastStationId = '${session.targetStationId}';
          session.targetStationId = '${stationList[index + 1].id}';

          sessionController.session.value?.lastStationId =
              '${session.targetStationId}';
          sessionController.session.value?.targetStationId =
              '${stationList[index + 1].id}';
          sessionController.session.refresh();

          await hiveService.storeSession(session);
        } else {
          print('not greater than index');
          session.isReversed = !session.isReversed;
          session.lastStationId = '${session.targetStationId}';
          session.targetStationId = '${stationList[stationList.length - 1].id}';

          sessionController.session.value?.lastStationId =
              '${session.targetStationId}';
          sessionController.session.value?.targetStationId =
              '${stationList[stationList.length - 1].id}';
          sessionController.session.refresh();
          await hiveService.storeSession(session);
        }

        print(
            "updateTargetStationId You are within 5 meters of the target location.");
      } else {
        print(
            "updateTargetStationId You are not within 5 meters of the target location.");
      }
    } else {
      print('updateTargetStationId empty updateTargetStationId');
    }
  }

  Future<void> logoutProcess(BuildContext context) async {
    // await hiveService.clearFilipayCards();
    // await hiveService.clearRoutes();
    // await hiveService.clearSession();
    // await hiveService.clearStations();
    // await hiveService.clearTapin();
    // await hiveService.clearTransaction();
    if (tapoutController.transaction.isNotEmpty) {
      SweetAlertUtils.showInformationDialog(context,
          title: 'Syncing',
          thisTitle: "There's Unsync data, please sync all first",
          onConfirm: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UnsyncPage()),
        );
      });
    } else {
      dialogUtils.showLoadingDialog(context, 'Logging out');

      Future.delayed(Duration(seconds: 1), () async {
        await deviceInfoService.stopLocation();

        await Hive.deleteFromDisk();

        tapinController.tapin.clear();
        sessionController.session.value = null;
        tapoutController.transaction.clear();

        udpService.closeUDP();
        NfcManager.instance.stopSession();
        Navigator.of(context).pop();
        Get.offAllNamed(Routes.LOGIN);
      });
    }

    // Get.offAll(() => LoginPage());
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginPage()),
    // );
  }
}
