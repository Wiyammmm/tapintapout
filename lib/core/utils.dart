import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tapintapout/backend/api/apiServices.dart';
import 'package:tapintapout/backend/printer/printServices.dart';
import 'package:tapintapout/backend/printer/printerController.dart';
import 'package:tapintapout/backend/services/deviceInfo_services.dart';
import 'package:tapintapout/backend/services/generator.dart';
import 'package:tapintapout/backend/services/getdata_services.dart';
import 'package:tapintapout/backend/services/process.dart';
import 'package:tapintapout/backend/services/udp_services.dart';
import 'package:tapintapout/controllers/coopinfo_controller.dart';
import 'package:tapintapout/controllers/data_controller.dart';
import 'package:tapintapout/controllers/permission_controller.dart';
import 'package:tapintapout/controllers/session_controller.dart';
import 'package:tapintapout/controllers/station_controller.dart';
import 'package:tapintapout/controllers/tapin_controller.dart';
import 'package:tapintapout/controllers/tapout_controller.dart';
import 'package:tapintapout/controllers/userinfo_controller.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/data/api_provider.dart';
import 'package:tapintapout/data/hive_service.dart';
import 'package:tapintapout/presentation/widgets/dialogs.dart';

final myBox = Hive.box('myBox');
PrintServices printServices = Get.put(PrintServices());
FlutterTts flutterTts = FlutterTts();
ApiServices apiServices = ApiServices();
GeneratorServices generatorServices = GeneratorServices();
SweetAlertUtils sweetAlertUtils = SweetAlertUtils();
DialogUtils dialogUtils = DialogUtils();
ApiProvider apiProvider = ApiProvider();
HiveService hiveService = HiveService();
ProcessServices processServices = ProcessServices();
SessionController sessionController = Get.put(SessionController());
TapinController tapinController = Get.put(TapinController());
TapoutController tapoutController = Get.put(TapoutController());
UdpService udpService = Get.put(UdpService());
DataController dataController = Get.put(DataController());
DeviceInfoService deviceInfoService = Get.put(DeviceInfoService());
CoopInfoController coopInfoController = CoopInfoController();
UserInfoController userInfoController = UserInfoController();
StationController stationController = StationController();
GetDataServices getDataServices = GetDataServices();
PermissionController permissionController = Get.put(PermissionController());
PrinterController printerController = Get.put(PrinterController());
