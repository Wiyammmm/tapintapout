import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/hive_service.dart';
import '../models/station_model.dart';

class StationController extends GetxService {
  var stations = <StationModel>[].obs;
  var filteredStation = <StationModel>[].obs;
  HiveService hiveService = HiveService();

  // Future<void> fetchStationsByRouteId(String routeId) async {
  //   var allStations = await Hive.openBox<StationModel>('stations');

  //   stations.value = allStations.values
  //       .where((station) => station.routeId == routeId)
  //       .toList()
  //     ..sort((a, b) =>
  //         a.stationNum.compareTo(b.stationNum)); // Sorting by stationNum
  // }

  Future<List<StationModel>> fetchStationsByRouteId(String routeId) async {
    var allStations = await Hive.openBox<StationModel>('stations');

    var filteredStations = allStations.values
        .where((station) => station.routeId == routeId)
        .toList()
      ..sort((a, b) => a.stationNum.compareTo(b.stationNum));
    filteredStation.value = filteredStations;
    filteredStation.refresh();
    return filteredStations;
  }
}
