import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tapintapout/controllers/coopinfo_controller.dart';
import 'package:tapintapout/controllers/permission_controller.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/filipaycard_model.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/vehicle_model.dart';
import '../data/api_provider.dart';
import '../data/hive_service.dart';
import '../models/route_model.dart';
import '../models/station_model.dart';
import 'package:http/http.dart' as http;

class DataController extends GetxService {
  var isLoading = false.obs;
  var routes = <RouteModel>[].obs;
  var filteredRoutes = <RouteModel>[].obs;
  var selectedRoute = Rxn<RouteModel>();
  var filteredVehicles = <VehicleModel>[].obs;
  var selectedVehicle = Rx<VehicleModel?>(null);
  var progress = 0.0.obs;
  var progressText = "fetching Routes".obs;
  var filipayCards = <FilipayCardModel>[].obs;
  var vehicles = <VehicleModel>[].obs;
  RxMap<String, dynamic> errorPrompt = <String, dynamic>{}.obs;
  var isRouteVisible = false.obs;
  var isVehicleVisible = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAndStoreData(); // Automatically fetch and display data when the page loads
  // }

  Future<void> initializedData() async {
    await deviceInfoService.getDeviceModel();
    await deviceInfoService.getDeviceSerialNumber();
    Get.put(PermissionController());
    List<FilipayCardModel> filipaycards = await hiveService.getFilipayCards();
    filipayCards.value = filipaycards;
    await coopInfoController.updateCoopInfoValuefromHive();
    await userInfoController.updateuserInfoValuefromHive();

    routes.value = await hiveService.getRoutes();
    vehicles.value = await hiveService.getVehicles();

    tapinController.tapin.value = await hiveService.getTapin();
    sessionController.session.value = await hiveService.getSession();
    print(
        'sessionController.session.value:${sessionController.session.value?.routeId}');

    if (sessionController.session.value != null) {
      getSelectedRoute(sessionController.session.value!.routeId);
      if (sessionController.session.value!.vehicleId != '') {
        selectedVehicle.value = vehicles.firstWhere((vehicle) =>
            vehicle.id == sessionController.session.value!.vehicleId);
      }

      if (sessionController.session.value!.routeId != '') {
        await stationController
            .fetchStationsByRouteId(sessionController.session.value!.routeId);
      }
    }

    tapoutController.transaction.value = await hiveService.getTransaction();
    tapoutController.transaction.refresh();
    if (dataController.filipayCards.isNotEmpty &&
        tapinController.tapin.isNotEmpty) {
      if (selectedRoute.value == null) {
        fetchAndStoreData();
      } else {
        updateFilipayCard();
      }
    }
  }

  Future<void> fetchAndStoreData() async {
    isLoading.value = true;
    errorPrompt.clear();
    try {
      print('filipay card is empty');

      List<String> progressTextList = [
        'fetching Routes',
        'fetching Stations',
        'fetching Vehicles',
        'fetching FilipayCards',
      ];
      List<Future> apiRequests = [
        apiProvider.fetchRoutes(),
        apiProvider.fetchStations(),
        apiProvider.fetchVehicles(),
        apiProvider.fetchFilipayCards(),
      ];

      int totalRequests = apiRequests.length;
      final results = [];
      for (var i = 0; i < apiRequests.length; i++) {
        // Update the progress text before each API call
        progressText.value = progressTextList[i];

        // Await the API call
        var result = await apiRequests[i];
        results.add(result); // Store the result

        // Update progress after each API call
        progress.value = (i + 1) / totalRequests;
      }

      // final routesResponse = await apiProvider.fetchRoutes();
      // final stationsResponse = await apiProvider.fetchStations();
      // final filipayCardResponse = await apiProvider.fetchFilipayCards();
      // // Convert responses to models and store in Hive
      List<RouteModel> routesList = (results[0] as List)
          .map((data) => RouteModel(
              id: data['_id'],
              coopId: data['coopId'],
              origin: data['origin'],
              destination: data['destination'],
              minimum_fare: double.parse("${data['minimum_fare']}"),
              maximumFare: double.parse("${data['maximumFare']}"),
              discount: data['discount'],
              pricePerKM: double.parse("${data['pricePerKM']}"),
              first_km: double.parse("${data['first_km']}"),
              routeLoop: data['routeLoop']))
          .toList();

      List<StationModel> stations = (results[1] as List)
          .map((data) => StationModel(
              id: data['_id'],
              coopId: data['coopId'],
              lat: double.parse(data['lat']),
              long: double.parse(data['long']),
              radius: double.parse("${data['radius']}"),
              km: double.parse("${data['km']}"),
              stationName: data['stationName'],
              stationNum: data['stationNum'],
              routeId: data['routeId']))
          .toList();

      List<VehicleModel> vehicleList = (results[2] as List)
          .map((data) => VehicleModel(
              id: data['_id'],
              coopId: data['coopId'],
              vehicle_no: data['vehicle_no'],
              plate_no: data['plate_no']))
          .toList();

      List<FilipayCardModel> filipayCardsList = (results[3] as List)
          .map((data) => FilipayCardModel(
              id: data['_id'],
              cardID: data['cardID'],
              balance: double.parse("${data['balance']}"),
              sNo: data['sNo'],
              cardType: data['cardType']))
          .toList();

      if (routesList.isNotEmpty) {
        await hiveService.storeRoutes(routesList);
        routes.value = routesList;
        filteredRoutes.value = routesList;
      }
      if (stations.isNotEmpty) {
        await hiveService.storeStations(stations);
        stationController.stations.value = stations;
      }
      if (filipayCardsList.isNotEmpty) {
        await hiveService.storeFilipayCards(filipayCardsList);
        filipayCards.value = filipayCardsList;
      }

      if (vehicleList.isNotEmpty) {
        await hiveService.storeVehicles(vehicleList);

        vehicles.value = vehicleList;
        filteredVehicles.value = vehicleList;
      }

      if (sessionController.session.value != null) {
        if (sessionController.session.value!.routeId != '') {
          await stationController
              .fetchStationsByRouteId(sessionController.session.value!.routeId);
        }
      }

      errorPrompt.value.clear();

      if (routesList.isEmpty || stations.isEmpty || filipayCardsList.isEmpty) {
        errorPrompt.value = {
          'title': 'Slow or No Internet',
          'label': 'Click ok to refetch',
          'isCancel': false
        };
      }
      print('end fetching');

      // List<StationModel> filteredStations = await stationController
      //     .fetchStationsByRouteId(sessionController.session.value!.routeId);
      // for (var station in filteredStations) {
      //   print('new Station ID: ${station.id}');
      //   print('new Station Name: ${station.stationName}');
      //   print('new Station Number: ${station.stationNum}');
      //   print('new Latitude: ${station.lat}');
      //   print('new Longitude: ${station.long}');
      //   print('new  ---');
      // }

      isLoading.value = false;
      ;
    } catch (e) {
      print('fetching error: $e');
      if (e.toString().contains('ClientException ')) {
        print('ClientException with SocketException occurred');
        errorPrompt.value = {
          'title': 'Slow or No Internet',
          'label': 'Click ok to refetch',
          'isCancel': false
        };
      } else {
        errorPrompt.value = {
          'title': 'Something went wrong',
          'label': 'Click ok to refetch',
          'isCancel': false
        };
      }

      print("errorPrompt: ${errorPrompt.value}");
      isLoading(false);
    }
  }

  void filterRoutes(String query) {
    if (query.isEmpty) {
      filteredRoutes.value = routes;
    } else {
      filteredRoutes.value = routes
          .where((route) =>
              route.origin.toLowerCase().contains(query.toLowerCase()) ||
              route.destination.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      filteredVehicles.value = vehicles;
    } else {
      filteredVehicles.value = vehicles
          .where((vehicle) =>
              vehicle.vehicle_no.toLowerCase().contains(query.toLowerCase()) ||
              vehicle.plate_no.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> getSelectedRoute(String id) async {
    final routeList = await hiveService.getRoutes();
    selectedRoute.value = routeList.firstWhere((route) => route.id == id);
    print(
        'selectedRoute.value: ${selectedRoute.value?.origin}-${selectedRoute.value?.destination}');
  }

  void updateSession(String routeid, String lastStationId,
      String targetStationId, String vehicleId) async {
    SessionModel session = SessionModel(
        routeId: routeid,
        lastStationId: lastStationId,
        targetStationId: targetStationId,
        vehicleId: vehicleId);
    sessionController.session.value = session;
    print(
        'sessionController Route ID: ${sessionController.session.value?.routeId}');
    print(
        'sessionController Last Station ID: ${sessionController.session.value?.lastStationId}');
    print(
        'sessionController startget Station ID: ${sessionController.session.value?.targetStationId}');
    await hiveService.storeSession(session);
  }

  Future<void> updateFilipayCard() async {
    print('updateFilipayCard called');
    try {
      apiProvider.cancelRequest();
      apiProvider.openRequest();
      final filipayCardResponse = await apiProvider.fetchFilipayCards();

      List<FilipayCardModel> filipayCardsList = filipayCardResponse
          .map((data) => FilipayCardModel(
              id: data['_id'],
              cardID: data['cardID'],
              balance: double.parse("${data['balance']}"),
              sNo: data['sNo'],
              cardType: data['cardType']))
          .toList();

      await hiveService.storeFilipayCards(filipayCardsList);
      if (filipayCardsList.isNotEmpty) {
        filipayCards.value = filipayCardsList;
        filipayCards.refresh();
        print('updateFilipayCard successfully');
      } else {
        print('updateFilipayCard not updated bcs empty');
      }
    } catch (e) {
      print('error updateFilipayCard: $e');
      updateFilipayCard();
    }
  }

  Future<Map<String, dynamic>> sendTransaction(
      Map<String, dynamic> item) async {
    Map<String, dynamic> response = {
      'messages': {'code': 1, 'message': 'Something went wrong'}
    };
    try {
      if (item['status'] == 'tapin') {
        final tapinResponse = await apiProvider.tapinTransaction(item);
        print('tapinResponse: $tapinResponse');
        if (tapinResponse.isNotEmpty) {
          if (tapinResponse['messages']['code'] == 0) {
            return tapinResponse;
          } else {
            response['messages']['message'] =
                tapinResponse['messages']['message'];
          }
        }
      } else if (item['status'] == 'tapout') {
        final tapoutResponse = await apiProvider.tapoutTransaction(item);
        print('tapoutResponse: $tapoutResponse');
        if (tapoutResponse['messages']['code'] == 0) {
          return tapoutResponse;
        } else {
          response['messages']['message'] =
              tapoutResponse['messages']['message'];
        }
      } else {
        print('invalid item');
      }
      return response;
    } catch (e) {
      print('error sendTransaction: $e');
      return response;
    }
  }
}
