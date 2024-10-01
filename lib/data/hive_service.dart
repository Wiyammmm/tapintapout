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
    var box = await Hive.openBox<RouteModel>('routes');
    // Replace existing entries
    for (int i = 0; i < routes.length; i++) {
      if (i < box.length) {
        // Overwrite the existing route at index i
        await box.putAt(i, routes[i]);
      } else {
        // If there are more routes than existing entries, add new ones
        await box.add(routes[i]);
      }
    }
  }

  Future<void> clearRoutes() async {
    var box = await Hive.openBox<RouteModel>('routes');
    await box.clear();
  }

  Future<void> storeStations(List<StationModel> stations) async {
    var box = await Hive.openBox<StationModel>('stations');
    await box.clear();
    await box.addAll(stations);
  }

  Future<void> storeVehicles(List<VehicleModel> vehicles) async {
    var box = await Hive.openBox<VehicleModel>('vehicles');
    await box.clear();
    await box.addAll(vehicles);
  }

  Future<void> clearStations() async {
    var box = await Hive.openBox<StationModel>('stations');
    await box.clear();
  }

  Future<void> storeFilipayCards(List<FilipayCardModel> filipayCards) async {
    var box = await Hive.openBox<FilipayCardModel>('filipayCards');
    // await box.clear();
    Map<int, FilipayCardModel> cardMap = {
      for (int i = 0; i < filipayCards.length; i++) i: filipayCards[i]
    };
    await box.putAll(cardMap);
    // await box.addAll(filipayCards);
  }

  Future<void> clearFilipayCards() async {
    var box = await Hive.openBox<FilipayCardModel>('filipayCards');
    await box.clear();
    print(box.values.toList());
  }

  Future<void> storeCoopInfo(CoopInfoModel coop) async {
    var box = await Hive.openBox<CoopInfoModel>('coopInfo');
    await box.clear();
    await box.add(coop);
  }

  Future<CoopInfoModel?> getCoopInfo() async {
    var box = await Hive.openBox<CoopInfoModel>('coopInfo');
    return box.isNotEmpty
        ? box.getAt(0)
        : null; // Get the first item or return null
  }

  Future<void> storeUserInfo(UserInfoModel user) async {
    var box = await Hive.openBox<UserInfoModel>('userInfo');
    await box.clear();
    await box.add(user);
  }

  Future<UserInfoModel?> getUserInfo() async {
    var box = await Hive.openBox<UserInfoModel>('userInfo');
    return box.isNotEmpty
        ? box.getAt(0)
        : null; // Get the first item or return null
  }

  Future<void> storeSession(SessionModel session) async {
    var box = await Hive.openBox<SessionModel>('session');
    await box.clear();
    await box.add(session);
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
    List<TapinModel> tapinlist = box.values.toList();
    // Iterate through all entries in the box
    // try {
    // TapinModel? tapin = tapinlist.firstWhere(
    //   (tapin) => tapin.cardId == '123' && tapin.status == 'tapin',
    // );
    int observableIndex = tapinController.tapin.value.indexWhere(
        (element) => element.cardId == cardId && element.status == 'tapin');
    print(
        'updatetapin tapin station: ${tapinController.tapin.value[observableIndex].tapinStationId}');
    print(
        'updatetapin tapout station: ${sessionController.session.value!.lastStationId}');
    Map<String, dynamic> dataUpdate = await getDataServices.tapinUpdate(
        tapinController.tapin.value[observableIndex].tapinStationId,
        sessionController.session.value!.lastStationId,
        cardId);

    tapinController.tapin.value[observableIndex].status =
        newStatus; // Update the status directly
    tapinController.tapin.value[observableIndex].destination = destination;
    tapinController.tapin.value[observableIndex].dateTime =
        getDataServices.getDateTime();

    tapinController.tapin.value[observableIndex].kmrun = dataUpdate['kmrun'];
    tapinController.tapin.value[observableIndex].fare = dataUpdate['fare'];
    tapinController.tapin.value[observableIndex].discount =
        dataUpdate['discount'];
    tapinController.tapin.value[observableIndex].amount = dataUpdate['amount'];
    await box.clear();
    await box.addAll(tapinController.tapin.value);

    TransactionModel transaction = TransactionModel(
        coopId: coopInfoController.coopInfo.value!.id,
        cardId: cardId,
        tapOutLat: deviceInfoService.lat.value,
        tapOutLong: deviceInfoService.long.value,
        tapInLat: tapinController.tapin.value[observableIndex].tapinLat,
        tapInLong: tapinController.tapin.value[observableIndex].tapinLong,
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
        ticketNumber:
            tapinController.tapin.value[observableIndex].ticketNumber);

    await hiveService.addTransaction(transaction);

    printServices.printTransactionReceipt({
      'ticketNumber': tapinController.tapin.value[observableIndex].ticketNumber,
      'amount':
          double.parse(dataUpdate['amount'].toString()).toStringAsFixed(2),
      'discount':
          double.parse(dataUpdate['discount'].toString()).toStringAsFixed(2),
      'fare': double.parse(dataUpdate['fare'].toString()).toStringAsFixed(2),
      'kmrun': double.parse(dataUpdate['kmrun'].toString()).toStringAsFixed(2),
      'origin': tapinController.tapin.value[observableIndex].origin,
      'destination': tapinController.tapin.value[observableIndex].destination,
    });
    // } catch (e) {
    //   print('updateTapin no found: $e');
    // }

    // for (int i = 0; i < box.length; i++) {
    //   TapinModel tapin = box.getAt(i)!;
    //   print(
    //       'cardId: ${tapin.cardId},tapinStationId:${tapin.tapinStationId},status:${tapin.status}');
    //   if (tapin.cardId == cardId) {
    //     // Update the status
    //     tapin.status = newStatus; // Update the status in the Hive object

    //     // Update the data in the Hive box
    //     await box.putAt(i, tapin); // Save the updated object back to Hive

    //     // Update the observable list
    //     int observableIndex = tapinController.tapin.value.indexWhere(
    //         (element) => element.cardId == cardId && element.status == 'tapin');
    //     if (observableIndex != -1) {
    //       tapinController.tapin.value[observableIndex].status =
    //           newStatus; // Update the status directly
    //       tapinController.tapin.value[observableIndex].destination =
    //           destination;
    //     }
    //   }
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
    tapoutController.transaction.value.add(tapout);
  }

  Future<void> removeTransactionFromHive(
      String ticketNumber, String status) async {
    // Open the Hive box where TransactionModels are stored
    var box = await Hive.openBox<TransactionModel>('transaction');
    // Get the current list of transactions
    List<TransactionModel> transactions = box.values.toList();
    // Find the transaction to remove based on its ID
    transactions.removeWhere((transaction) =>
        transaction.ticketNumber == ticketNumber &&
        transaction.status == status);

    tapoutController.transaction.value = transactions;
    tapoutController.transaction.refresh();
    // Clear the existing transactions in the box
    await box.clear();
    // Save the filtered list back to Hive
    await box.addAll(transactions);
  }

  Future<void> clearTransaction() async {
    var box = await Hive.openBox<TransactionModel>('transaction');
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
    return box.isNotEmpty
        ? box.getAt(0)
        : null; // Get the first item or return null
  }

  Future<List<FilipayCardModel>> getFilipayCards() async {
    var box = await Hive.openBox<FilipayCardModel>('filipayCards');

    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }

  Future<List<RouteModel>> getRoutes() async {
    var box = await Hive.openBox<RouteModel>('routes');

    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }

  Future<List<VehicleModel>> getVehicles() async {
    var box = await Hive.openBox<VehicleModel>('vehicles');

    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }

  Future<List<StationModel>> getStations() async {
    var box = await Hive.openBox<StationModel>('stations');

    // Retrieve all the stored FilipayCardModel entries
    return box.values.toList();
  }
}
