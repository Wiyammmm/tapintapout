import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/tapin_model.dart';

class TapinController extends GetxService {
  var tapin = <TapinModel>[].obs;

  Future<void> printTapin() async {
    tapin.value = await hiveService.getTapin();
    print('printTapin:${tapin.value}');
    for (var element in tapin) {
      print(
          'cardId: ${element.cardId},tapinStationId: ${element.tapinStationId}');
    }
  }
}
