import 'package:get/get.dart';
import 'package:tapintapout/presentation/pages/homePage.dart';
import 'package:tapintapout/presentation/pages/loginPage.dart';
import 'package:tapintapout/presentation/pages/selectRoute.dart';
part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.ROUTE_DETAIL, page: () => SelectRoutePage()),
  ];
}
