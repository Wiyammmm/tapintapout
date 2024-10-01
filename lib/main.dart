import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapintapout/backend/services/udp_services.dart';
import 'package:tapintapout/core/theme.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/coopinfo_model.dart';
import 'package:tapintapout/models/endpoint_model.dart';
import 'package:tapintapout/models/filipaycard_model.dart';
import 'package:tapintapout/models/route_model.dart';
import 'package:tapintapout/models/session_model.dart';
import 'package:tapintapout/models/station_model.dart';
import 'package:tapintapout/models/tapin_model.dart';
import 'package:tapintapout/models/transaction_model.dart';
import 'package:tapintapout/models/userinfo_model.dart';
import 'package:tapintapout/models/vehicle_model.dart';
import 'package:tapintapout/routes/app_pages.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(RouteModelAdapter());
  Hive.registerAdapter(StationModelAdapter());
  Hive.registerAdapter(SessionModelAdapter());
  Hive.registerAdapter(TapinModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(FilipayCardModelAdapter());
  Hive.registerAdapter(CoopInfoModelAdapter());
  Hive.registerAdapter(UserInfoModelAdapter());
  Hive.registerAdapter(VehicleModelAdapter());

  Hive.registerAdapter(EndpointModelAdapter());
  await dataController.initializedData();
  await Hive.openBox('myBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute:
          (dataController.filipayCards.isEmpty && tapinController.tapin.isEmpty)
              ? Routes.LOGIN
              : routeController.selectedRoute.value == null
                  ? Routes.ROUTE_DETAIL
                  : Routes.HOME,
      getPages: AppPages.routes,
    );
    // MaterialApp(
    //   title: 'Filipay',
    //   debugShowCheckedModeBanner: false,
    //   theme: appTheme,
    //   home: const LoginPage(),
    // );
  }
}
