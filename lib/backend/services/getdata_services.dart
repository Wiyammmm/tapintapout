import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/filipaycard_model.dart';
import 'package:tapintapout/models/station_model.dart';
import 'package:tapintapout/models/vehicle_model.dart';

class GetDataServices {
  Future<String> getOrigin(String stationId) async {
    String origin = '';
    print('origin stationId: $stationId');
    try {
      List<StationModel> stationList = await stationController
          .fetchStationsByRouteId(sessionController.session.value!.routeId);
      // for (var station in stationController.filteredStation) {
      //   print('origin Station ID: ${station.id}');
      //   print('origin Station Name: ${station.stationName}');
      //   print('origin Station Number: ${station.stationNum}');
      //   print('origin Latitude: ${station.lat}');
      //   print('origin Longitude: ${station.long}');
      //   print('origin ---');
      // }

      StationModel station;
      station = stationController.filteredStation
          .where((station) => station.id == stationId)
          .first;
      if (station != null) {
        origin = station.stationName;
        print('origin: $origin');
        // Do something with the station
      } else {
        print('No matching station found.');
      }
    } catch (e) {
      print('error get Origin: $e');
    }
    return origin;
  }

  String getDateTime() {
    DateTime now = DateTime.now();
    print('datenow: ${now.toString()}');
    return DateFormat('MM-dd-yyyy hh:mm a').format(now);
  }

  Future<Map<String, dynamic>> tapinUpdate(String originStationId,
      String destinationStationId, String cardid) async {
    Map<String, dynamic> dataResponse = {
      'kmrun': 0,
      'fare': dataController.selectedRoute.value!.maximumFare,
      'discount': 0,
      'amount': 0,
      'tapinStationName': '',
      'tapOutStationName': '',
      'vehicleNo': '',
      'plateNumber': ''
    };

    double kmrun = 0;
    double fare = 0;
    double discount = 0;
    double amount = 0;

    VehicleModel selectedVehicle =
        await getDataServices.getSelectedVehicleInfo();

    List<FilipayCardModel> filipaycards = await hiveService.getFilipayCards();
    FilipayCardModel card =
        filipaycards.firstWhere((card) => card.cardID == cardid);

    List<StationModel> stationList = await stationController
        .fetchStationsByRouteId(sessionController.session.value!.routeId);

// start get kmrun
    StationModel originStation = stationList.firstWhere(
      (station) => station.id == originStationId, // Condition: id equals 1
      orElse: () => throw Exception('Station not found'),
    );

    StationModel destinationStation = stationList.firstWhere(
      (station) => station.id == destinationStationId, // Condition: id equals 1
      orElse: () => throw Exception('Station not found'),
    );
    print('origin station ${originStation.stationName}');
    print('destination station: ${destinationStation.stationName}');
    print('origin km: ${originStation.km}');
    print('destination km: ${destinationStation.km}');

    kmrun = (originStation.km - destinationStation.km).abs();
    // end get kmrun

    // start get fare
    if (kmrun < dataController.selectedRoute.value!.first_km) {
      fare = dataController.selectedRoute.value!.minimum_fare;
    } else {
      fare = ((kmrun - dataController.selectedRoute.value!.first_km) *
              dataController.selectedRoute.value!.pricePerKM) +
          dataController.selectedRoute.value!.minimum_fare;
    }
    // end get fare

    // start get discount
    print('tapinUpdate cardid: $cardid');
    // print('tapinUpdate filipayCards: ${dataController.filipayCards[0].cardID}');
    FilipayCardModel filipayCardInfo =
        dataController.filipayCards.firstWhere((card) => card.cardID == cardid);

    if (filipayCardInfo.sNo.contains('SND')) {
      discount = fare * (dataController.selectedRoute.value!.discount / 100);
    }

    // end get discount

    // start get amount
    amount = fare - discount;
    // end get amount

    udpService.sendMessage(
        "tapout:{ \'remainingBalance\': ${card.balance + amount}, \'maxFare\': ${dataController.selectedRoute.value!.maximumFare},\'refund\': ${dataController.selectedRoute.value!.maximumFare - amount},\'kmRun\': $kmrun,\'fare\': $fare,\'discount\': $discount}");
    dialogUtils.showTapout(Get.context!, () {}, {
      'remainingBalance': card.balance + amount,
      'maxFare': dataController.selectedRoute.value!.maximumFare,
      'refund': dataController.selectedRoute.value!.maximumFare - amount,
      'kmRun': kmrun,
      'fare': fare,
      'discount': discount
    });

    dataResponse['kmrun'] = kmrun;
    dataResponse['fare'] = fare;
    dataResponse['discount'] = discount;
    dataResponse['amount'] = amount;
    dataResponse['tapinStationName'] = originStation.stationName;
    dataResponse['tapOutStationName'] = destinationStation.stationName;
    dataResponse['vehicleNo'] = selectedVehicle.vehicle_no;
    dataResponse['plateNumber'] = selectedVehicle.plate_no;
    print('kmRun: ${dataResponse['kmrun']}');
    print('fare: ${dataResponse['fare']}');
    print('discount: ${dataResponse['discount']}');
    print('amount: ${dataResponse['amount']}');
    return dataResponse;
  }

  String getCardType(String cardid) {
    String cardType = 'regular';

    FilipayCardModel filipayCardInfo =
        dataController.filipayCards.firstWhere((card) => card.cardID == cardid);

    if (filipayCardInfo.sNo.contains('SND')) {
      cardType = 'discounted';
    }

    return cardType;
  }

  Future<String> getStationName(String stationId) async {
    List<StationModel> stationList = await stationController
        .fetchStationsByRouteId(sessionController.session.value!.routeId);
    StationModel station = stationList.firstWhere(
      (station) => station.id == stationId, // Condition: id equals 1
      orElse: () => throw Exception('Station not found'),
    );
    print('station.stationName: ${station.stationName}');
    return station.stationName;
  }

  Future<VehicleModel> getSelectedVehicleInfo() async {
    VehicleModel vehicle;
    try {
      vehicle = dataController.vehicles.firstWhere((vehicle) =>
          vehicle.id == sessionController.session.value!.vehicleId);
      print('selected vehicle: ${vehicle.vehicle_no}:${vehicle.plate_no}');
      return vehicle;
    } catch (e) {
      print(e);
      throw Future.error(e);
    }
  }
}
