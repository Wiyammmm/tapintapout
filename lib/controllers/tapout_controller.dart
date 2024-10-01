import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/tapin_model.dart';
import 'package:tapintapout/models/transaction_model.dart';

class TapoutController extends GetxService {
  var transaction = <TransactionModel>[].obs;

  Future<void> printTapin() async {
    transaction.value = await hiveService.getTransaction();
    for (var element in transaction) {
      print('transaction: $element');
    }
  }
}
