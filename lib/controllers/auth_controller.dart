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
  RxMap<String, dynamic> errorPrompt = <String, dynamic>{}.obs;

  Future<void> login(String email, String password) async {
    var response;
    isLoading(true);
    try {
      String deviceId = await deviceInfoService.getDeviceSerialNumber();
      response = await apiProvider.login(email, password, deviceId);
      print('response: $response');
      isLoading(false);
      if (response['messages']['code'] != 0) {
        errorPrompt.value = {
          'title': '${response['messages']['message']}',
          'label': 'Please try again',
          'isCancel': false
        };
      } else {
        var userinfo = response['response']['userInfo'];
        var coopinfo = response['response']['coopInfo'];
        UserInfoModel userInfoModel = UserInfoModel(
            firstName: userinfo['firstName'],
            lastName: userinfo['lastName'],
            email: userinfo['email'],
            password: userinfo['password']);
        CoopInfoModel coopInfoModel = CoopInfoModel(
            id: coopinfo['_id'],
            cooperativeName: coopinfo['cooperativeName'],
            cooperativeCodeName: coopinfo['cooperativeCodeName'],
            minimum_fare: double.parse('${coopinfo['minimum_fare']}'),
            pricePerKM: double.parse(coopinfo['pricePerKM'].toString()),
            isNumeric: coopinfo['isNumeric'],
            coopType: coopinfo['coopType'],
            maximumBaggage: double.parse(coopinfo['maximumBaggage'].toString()),
            maximumFare: double.parse(coopinfo['maximumFare'].toString()),
            modeOfPayment: coopinfo['modeOfPayment'],
            balance: double.parse(coopinfo['balance'].toString()));
        await userInfoController.updateUserInfoValue(userInfoModel);
        await coopInfoController.updateCoopInfoValue(coopInfoModel);
        print('success');
        dataController.fetchAndStoreData();
        errorPrompt.value.clear();
        Get.offAllNamed(Routes.ROUTE_DETAIL);
      }
    } catch (e) {
      isLoading(false);
      print('login error: $e');
      if (response != null) {
        if (response.containsKey('messages')) {
          errorPrompt.value = {
            'title': '${response['messages']['message']}',
            'label': 'Please try again',
            'isCancel': false
          };
        }
      } else {
        errorPrompt.value = {
          'title': 'Something went wrong',
          'label': 'Please try again',
          'isCancel': false
        };
      }
    }

    // if (response['status'] == 'success') {
    //   // Save login details (JWT, etc.) if needed
    //   Get.offAllNamed(Routes.ROUTE_DETAIL);
    // } else {
    //   Get.snackbar('Error', 'Login failed');
    // }
  }
}
