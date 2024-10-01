import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/session_model.dart';

class SessionController extends GetxService {
  var session = Rxn<SessionModel>();

  Future<void> printSession() async {
    session.value = await hiveService.getSession();
    print(
        'Route ID: ${session.value!.routeId}, Last Station ID: ${session.value!.lastStationId}');
  }
}
