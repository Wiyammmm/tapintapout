import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/coopinfo_model.dart';

class CoopInfoController extends GetxService {
  var coopInfo = Rxn<CoopInfoModel>();

  Future<void> updateCoopInfoValuefromHive() async {
    CoopInfoModel? coopInfoModel = await hiveService.getCoopInfo();
    print('coopInfo: ${coopInfoModel?.cooperativeName}');
    coopInfo.value = coopInfoModel;
    coopInfo.refresh();
  }

  Future<void> updateCoopInfoValue(CoopInfoModel coopinfo) async {
    await hiveService.storeCoopInfo(coopinfo);
    coopInfo.value = coopinfo;
    coopInfo.refresh();
  }
}
