import 'package:get/get.dart';

class ConnectionController extends GetxService {
  var isConnected = false.obs;
  var tagData = "".obs;

  void setConnectionStatus(bool status) {
    isConnected.value = status;
  }

  void getTagData(String data) {
    tagData.value = data;
  }
}
