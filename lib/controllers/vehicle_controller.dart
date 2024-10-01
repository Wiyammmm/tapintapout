import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/vehicle_model.dart';

class VehicleController extends GetxController {
  var filteredVehicles = <VehicleModel>[].obs; // Filtered list
  var selectedVehicle = Rx<VehicleModel?>(null); // Selected vehicle
  var isVisible = false.obs;
  // @override
  // void onInit() {
  //   super.onInit();

  //   filteredVehicles.assignAll(dataController.vehicles);
  // }

  void filterVehicles(String query) {
    if (query.isEmpty) {
      filteredVehicles.assignAll(dataController.vehicles);
    } else {
      filteredVehicles.value = dataController.vehicles
          .where((vehicle) =>
              vehicle.vehicle_no.toLowerCase().contains(query.toLowerCase()) ||
              vehicle.plate_no.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void selectVehicle(VehicleModel vehicle) {
    selectedVehicle.value = vehicle;
  }
}
