import 'package:hive/hive.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/coopinfo_model.dart';
import 'package:tapintapout/models/filipaycard_model.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/tapin_model.dart';
import 'package:tapintapout/models/transaction_model.dart';
import 'package:tapintapout/models/userinfo_model.dart';
import 'package:tapintapout/models/vehicle_model.dart';
import '../models/route_model.dart';
import '../models/station_model.dart';

class HiveService {
  Future<void> storeRoutes(List<RouteModel> routes) async {
    var box = await Hive.openBox<List>('routes');
    await box.put('routesList', routes);
    // Replace existing entries
    // for (int i = 0; i < routes.length; i++) {
    //   if (i < box.length) {
    //     // Overwrite the existing route at index i
    //     await box.putAt(i, routes[i]);
    //   } else {
    //     // If there are more routes than existing entries, add new ones
    //     await box.add(routes[i]);
    //   }
    // }
  }

  Future<void> clearRoutes() async {
    var box = await Hive.openBox<List>('routes');
    await box.clear();
  }

  Future<void> storeStations(List<StationModel> stations) async {
    var box = await Hive.openBox<List>('stations');
    await box.put('stationsList', stations);
    // await box.clear();
    // await box.addAll(stations);
  }

  Future<void> storeVehicles(List<VehicleModel> vehicles) async {
    var box = await Hive.openBox<List>('vehicles');
    await box.put('vehiclesList', vehicles);
    // await box.clear();
    // await box.addAll(vehicles);
  }

  Future<void> clearStations() async {
    var box = await Hive.openBox<List>('stations');
    await box.clear();
  }

  Future<void> storeFilipayCards(List<FilipayCardModel> filipayCards) async {
    var box = await Hive.openBox<List>('filipayCards');

    await box.put('filipayCardsList', filipayCards);
    // await box.clear();
    // Map<int, FilipayCardModel> cardMap = {
    //   for (int i = 0; i < filipayCards.length; i++) i: filipayCards[i]
    // };
    // await box.putAll(cardMap);
    // await box.addAll(filipayCards);
  }

  Future<void> clearFilipayCards() async {
    var box = await Hive.openBox<List>('filipayCards');
    await box.clear();
    print(box.values.toList());
  }

  Future<void> storeCoopInfo(CoopInfoModel coop) async {
    var box = await Hive.openBox<CoopInfoModel>('coopInfo');
    await box.put('coopInfoKey', coop);
    // await box.clear();
    // await box.add(coop);
  }

  Future<CoopInfoModel?> getCoopInfo() async {
    var box = await Hive.openBox<CoopInfoModel>('coopInfo');
    return box.get('coopInfoKey');
    // return box.isNotEmpty
    //     ? box.getAt(0)
    //     : null; // Get the first item or return null
  }

  Future<void> storeUserInfo(UserInfoModel user) async {
    var box = await Hive.openBox<UserInfoModel>('userInfo');
    await box.put('userInfoKey', user);
    // await box.clear();
    // await box.add(user);
  }

  Future<UserInfoModel?> getUserInfo() async {
    var box = await Hive.openBox<UserInfoModel>('userInfo');
    return box.get('userInfoKey');
    // return box.isNotEmpty
    //     ? box.getAt(0)
    //     : null; // Get the first item or return null
  }

  Future<void> storeSession(SessionModel session) async {
    var box = await Hive.openBox<SessionModel>('session');
    await box.put('sessionKey', session);
    // await box.clear();
    // await box.add(session);
  }

  Future<void> clearSession() async {
    var box = await Hive.openBox<SessionModel>('session');
    await box.clear();
    sessionController.session.value = null;
  }

  // Future<void> storeTapin(List<TapinModel> tapin) async {
  //   var box = await Hive.openBox<TapinModel>('tapin');
  //   await box.clear();
  //   await box.addAll(tapin);
  // }

  Future<void> addTapin(TapinModel tapin) async {
    var box = await Hive.openBox<TapinModel>('tapin');
    await box.add(tapin);
    tapinController.tapin.value.add(tapin);
    tapinController.tapin.refresh();
  }

  Future<void> clearTapin() async {
    var box = await Hive.openBox<TapinModel>('tapin');
    tapinController.tapin.clear();
    await box.clear();
  }

  Future<List<TapinModel>> getTapin() async {
    var box = await Hive.openBox<TapinModel>('tapin');
    tapinController.tapin.value = box.values.toList();
    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }

  Future<void> updateTapin(
      String cardId, String newStatus, String destination) async {
    var box = await Hive.openBox<TapinModel>('tapin');
    // List<TapinModel> tapinlist = box.values.toList();
    // Iterate through all entries in the box
    // try {

    final tapinKey = box.keys.firstWhere(
      (key) {
        final tapin = box.get(key);
        return tapin?.cardId == cardId && tapin?.status == "tapin";
      },
      orElse: () => null, // Return null if no matching transaction is found
    );
    print('tapinKey: $tapinKey');

    if (tapinKey != null) {
      var tapin = box.get(tapinKey);

      int observableIndex = tapinController.tapin.indexWhere(
          (element) => element.cardId == cardId && element.status == 'tapin');

      Map<String, dynamic> dataUpdate = await getDataServices.tapinUpdate(
          tapin!.tapinStationId,
          sessionController.session.value!.lastStationId,
          cardId);

      var updatedTapin = TapinModel(
          cardId: tapin.cardId,
          tapinStationId: tapin.tapinStationId,
          tapoutStationId: sessionController.session.value!.lastStationId,
          tapinLat: tapin.tapinLat,
          tapoutLat: deviceInfoService.lat.value,
          tapinLong: tapin.tapinLong,
          tapoutLong: deviceInfoService.lat.value,
          status: newStatus,
          ticketNumber: tapin.ticketNumber,
          origin: tapin.origin,
          destination: destination,
          kmrun: dataUpdate['kmrun'],
          fare: dataUpdate['fare'],
          discount: dataUpdate['discount'],
          amount: dataUpdate['amount'],
          dateTime: getDataServices.getDateTime());

      await box.put(tapinKey, updatedTapin);

      tapinController.tapin[observableIndex] = updatedTapin;

      TransactionModel transaction = TransactionModel(
          coopId: coopInfoController.coopInfo.value!.id,
          cardId: cardId,
          tapOutLat: deviceInfoService.lat.value,
          tapOutLong: deviceInfoService.long.value,
          tapInLat: tapin.tapinLat,
          tapInLong: tapin.tapinLong,
          tapInStation: dataUpdate['tapinStationName'],
          tapOutStation: dataUpdate['tapOutStationName'],
          km_run: dataUpdate['kmrun'],
          amount: dataUpdate['amount'],
          discount: dataUpdate['discount'],
          fare: dataUpdate['fare'],
          cardType: getDataServices.getCardType(cardId),
          mop: 'card',
          status: 'tapout',
          maxfare: double.parse(
              coopInfoController.coopInfo.value!.maximumFare.toString()),
          ticketNumber: tapin.ticketNumber,
          vehicleNo: dataUpdate['vehicleNo'],
          plateNumber: dataUpdate['plateNumber'],
          routeId: sessionController.session.value!.routeId,
          driverId: userInfoController.userInfo.value!.id,
          date: getDataServices.getDateTime());

      await hiveService.addTransaction(transaction);

      printServices.printTransactionReceipt({
        'ticketNumber': tapin.ticketNumber,
        'amount':
            double.parse(dataUpdate['amount'].toString()).toStringAsFixed(2),
        'discount':
            double.parse(dataUpdate['discount'].toString()).toStringAsFixed(2),
        'fare': double.parse(dataUpdate['fare'].toString()).toStringAsFixed(2),
        'kmrun':
            double.parse(dataUpdate['kmrun'].toString()).toStringAsFixed(2),
        'origin': tapin.origin,
        'destination': destination,
        'date': updatedTapin.dateTime,
        'vehicleNo': dataUpdate['vehicleNo'],
        'plateNumber': dataUpdate['plateNumber']
      });
    }

    // // old

    // int observableIndex = tapinController.tapin.value.indexWhere(
    //     (element) => element.cardId == cardId && element.status == 'tapin');

    // print(
    //     'updatetapin tapin station: ${tapinController.tapin.value[observableIndex].tapinStationId}');
    // print(
    //     'updatetapin tapout station: ${sessionController.session.value!.lastStationId}');
    // Map<String, dynamic> dataUpdate = await getDataServices.tapinUpdate(
    //     tapinController.tapin.value[observableIndex].tapinStationId,
    //     sessionController.session.value!.lastStationId,
    //     cardId);

    // tapinController.tapin.value[observableIndex].status =
    //     newStatus; // Update the status directly
    // tapinController.tapin.value[observableIndex].destination = destination;
    // tapinController.tapin.value[observableIndex].dateTime =
    //     getDataServices.getDateTime();

    // tapinController.tapin.value[observableIndex].kmrun = dataUpdate['kmrun'];
    // tapinController.tapin.value[observableIndex].fare = dataUpdate['fare'];
    // tapinController.tapin.value[observableIndex].discount =
    //     dataUpdate['discount'];
    // tapinController.tapin.value[observableIndex].amount = dataUpdate['amount'];
    // await box.clear();
    // await box.addAll(tapinController.tapin.value);

    // TransactionModel transaction = TransactionModel(
    //     coopId: coopInfoController.coopInfo.value!.id,
    //     cardId: cardId,
    //     tapOutLat: deviceInfoService.lat.value,
    //     tapOutLong: deviceInfoService.long.value,
    //     tapInLat: tapinController.tapin.value[observableIndex].tapinLat,
    //     tapInLong: tapinController.tapin.value[observableIndex].tapinLong,
    //     tapInStation: dataUpdate['tapinStationName'],
    //     tapOutStation: dataUpdate['tapOutStationName'],
    //     km_run: dataUpdate['kmrun'],
    //     amount: dataUpdate['amount'],
    //     discount: dataUpdate['discount'],
    //     fare: dataUpdate['fare'],
    //     cardType: getDataServices.getCardType(cardId),
    //     mop: 'card',
    //     status: 'tapout',
    //     maxfare: double.parse(
    //         coopInfoController.coopInfo.value!.maximumFare.toString()),
    //     ticketNumber: tapinController.tapin.value[observableIndex].ticketNumber,
    //     vehicleNo: dataUpdate['vehicleNo'],
    //     plateNumber: dataUpdate['plateNumber'],
    //     date: getDataServices.getDateTime());

    // await hiveService.addTransaction(transaction);

    // printServices.printTransactionReceipt({
    //   'ticketNumber': tapinController.tapin.value[observableIndex].ticketNumber,
    //   'amount':
    //       double.parse(dataUpdate['amount'].toString()).toStringAsFixed(2),
    //   'discount':
    //       double.parse(dataUpdate['discount'].toString()).toStringAsFixed(2),
    //   'fare': double.parse(dataUpdate['fare'].toString()).toStringAsFixed(2),
    //   'kmrun': double.parse(dataUpdate['kmrun'].toString()).toStringAsFixed(2),
    //   'origin': tapinController.tapin.value[observableIndex].origin,
    //   'destination': tapinController.tapin.value[observableIndex].destination,
    //   'date': tapinController.tapin.value[observableIndex].dateTime,
    //   'vehicleNo': dataUpdate['vehicleNo'],
    //   'plateNumber': dataUpdate['plateNumber']
    // });
    // // end old
    // } catch (e) {
    //   print('updateTapin no found: $e');
    // }

    // Refresh the observable list to notify listeners of the change
    tapinController.tapin.refresh();
  }

  // Future<void> storeTransaction(List<TransactionModel> transaction) async {
  //   var box = await Hive.openBox<TransactionModel>('transaction');
  //   await box.clear();
  //   await box.addAll(transaction);
  // }
  Future<void> addTransaction(TransactionModel tapout) async {
    var box = await Hive.openBox<TransactionModel>('transaction');
    await box.add(tapout);
    tapoutController.transaction.add(tapout);
  }

  Future<void> removeTransactionFromHive(
      String ticketNumber, String status) async {
    // Open the Hive box where TransactionModels are stored
    var box = await Hive.openBox<TransactionModel>('transaction');

    // Find the transaction's key based on ticketNumber and status
    final transactionKey = box.keys.firstWhere(
      (key) {
        final transaction = box.get(key);
        return transaction?.ticketNumber == ticketNumber &&
            transaction?.status == status;
      },
      orElse: () => null, // Return null if no matching transaction is found
    );

    // If a matching transaction is found, remove it from the box
    if (transactionKey != null) {
      await box.delete(transactionKey);
    }

    // Update the controller with the updated transaction list
    tapoutController.transaction.value = box.values.toList();
    tapoutController.transaction.refresh();

    // // Open the Hive box where TransactionModels are stored
    // var box = await Hive.openBox<TransactionModel>('transaction');
    // // Get the current list of transactions
    // List<TransactionModel> transactions = box.values.toList();
    // // Find the transaction to remove based on its ID
    // transactions.removeWhere((transaction) =>
    //     transaction.ticketNumber == ticketNumber &&
    //     transaction.status == status);

    // tapoutController.transaction.value = transactions;
    // tapoutController.transaction.refresh();
    // // Clear the existing transactions in the box
    // await box.clear();
    // // Save the filtered list back to Hive
    // await box.addAll(transactions);
  }

  Future<void> clearTransaction() async {
    var box = await Hive.openBox<TapinModel>('transaction');
    await box.clear();
    tapoutController.transaction.clear();
  }

  Future<List<TransactionModel>> getTransaction() async {
    var box = await Hive.openBox<TransactionModel>('transaction');

    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }

  Future<SessionModel?> getSession() async {
    var box = await Hive.openBox<SessionModel>('session');
    return box.get('sessionKey');
    // return box.isNotEmpty
    //     ? box.getAt(0)
    //     : null; // Get the first item or return null
  }

  Future<List<FilipayCardModel>> getFilipayCards() async {
    var box = await Hive.openBox<List>('filipayCards');
    List<dynamic>? filipayCardsList = box.get('filipayCardsList');
    // Retrieve all the stored FilipayCardModel entries
    return filipayCardsList?.cast<FilipayCardModel>() ?? <FilipayCardModel>[];
  }

  Future<List<RouteModel>> getRoutes() async {
    var box = await Hive.openBox<List>('routes');
    List<dynamic>? routesList = box.get('routesList');
    // Retrieve all the stored FilipayCardModel entries
    return routesList?.cast<RouteModel>() ?? <RouteModel>[];
  }

  Future<List<VehicleModel>> getVehicles() async {
    var box = await Hive.openBox<List>('vehicles');
    List<dynamic>? vehicleList = box.get('vehiclesList');
    // Retrieve all the stored FilipayCardModel entries
    // return box.values.toList();
    return vehicleList?.cast<VehicleModel>() ?? <VehicleModel>[];
  }

  Future<List<StationModel>> getStations() async {
    var box = await Hive.openBox<List>('stations');
    List<dynamic>? stationsList = box.get('stationsList');
    // Retrieve all the stored FilipayCardModel entries
    return stationsList?.cast<StationModel>() ?? <StationModel>[];
  }
}
