import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tapintapout/controllers/userinfo_controller.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/coopinfo_model.dart';
import 'package:tapintapout/models/userinfo_model.dart';
import '../data/api_provider.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxService {
  var isLoading = false.obs;
  ApiProvider apiProvider = ApiProvider();
  // RxMap<String, dynamic> errorPrompt = <String, dynamic>{}.obs;
  Map<String, dynamic> errorPrompt = {};
  Future<void> login(String email, String password) async {
    var response;
    isLoading(true);
    // try {
    // String deviceId = await deviceInfoService.getDeviceSerialNumber();
    response = await apiProvider.login(
        email, password, deviceInfoService.serialNumber.value);
    print('response: $response');
    isLoading(false);

    if (response['messages']['code'] != 0) {
      print('login !=0');
      errorPrompt = {
        'title': '${response['messages']['message']}',
        'label': 'Please try again',
        'isCancel': false
      };
      // return;
    } else {
      // isLoading(false);
      errorPrompt.clear();
      print('login ok');
      var userinfo = response['response']['userInfo'];
      var coopinfo = response['response']['coopInfo'];
      UserInfoModel userInfoModel = UserInfoModel(
          id: userinfo['_id'],
          firstName: userinfo['firstName'],
          lastName: userinfo['lastName'],
          email: userinfo['email'],
          password: userinfo['password']);
      CoopInfoModel coopInfoModel = CoopInfoModel(
          id: coopinfo['_id'],
          cooperativeName: coopinfo['cooperativeName'],
          cooperativeCodeName: coopinfo['cooperativeCodeName'],
          coopType: coopinfo['coopType'],
          maximumBaggage: double.parse(coopinfo['maximumBaggage'].toString()),
          maximumFare: double.parse(coopinfo['maximumFare'].toString()),
          modeOfPayment: coopinfo['modeOfPayment'],
          balance: double.parse(coopinfo['balance'].toString()));
      await userInfoController.updateUserInfoValue(userInfoModel);
      await coopInfoController.updateCoopInfoValue(coopInfoModel);
      print('success');
      dataController.fetchAndStoreData();

      Get.offAllNamed(Routes.ROUTE_DETAIL);
    }
    // } catch (e) {
    //   isLoading(false);
    //   print('login error: $e');

    //   if (response != null) {
    //     print('login not null');
    //     if (response['messages']['message'] == 'OK') {
    //       response['messages']['message'] = 'Something went wrong';
    //     }
    //     if (response.containsKey('messages')) {
    //       print('login contains messages');
    //       errorPrompt = {
    //         'title': '${response['messages']['message']}',
    //         'label': 'Please try again',
    //         'isCancel': false
    //       };
    //     }
    //   } else {
    //     print('login null');
    //     errorPrompt = {
    //       'title': 'Something went wrong',
    //       'label': 'Please try again',
    //       'isCancel': false
    //     };
    //   }
    //   // return;
    // }

    // if (response['status'] == 'success') {
    //   // Save login details (JWT, etc.) if needed
    //   Get.offAllNamed(Routes.ROUTE_DETAIL);
    // } else {
    //   Get.snackbar('Error', 'Login failed');
    // }
  }
}
