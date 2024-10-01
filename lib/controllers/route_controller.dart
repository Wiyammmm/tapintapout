import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/route_model.dart';

class RouteController extends GetxService {
  var selectedRoute = Rxn<RouteModel>();

  Future<void> getSelectedRoute(String id) async {
    final routeList = await hiveService.getRoutes();
    selectedRoute.value = routeList.firstWhere((route) => route.id == id);
    print(
        'selectedRoute.value: ${selectedRoute.value?.origin}-${selectedRoute.value?.destination}');
  }
}
