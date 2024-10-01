import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/userinfo_model.dart';

class UserInfoController extends GetxService {
  var userInfo = Rxn<UserInfoModel>();

  Future<void> updateuserInfoValuefromHive() async {
    userInfo.value = await hiveService.getUserInfo();
    userInfo.refresh();
  }

  Future<void> updateUserInfoValue(UserInfoModel userinfo) async {
    await hiveService.storeUserInfo(userinfo);
    userInfo.value = userinfo;
    userInfo.refresh();
  }
}
