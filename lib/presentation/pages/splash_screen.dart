import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/presentation/pages/homePage.dart';
import 'package:tapintapout/presentation/pages/loginPage.dart';
import 'package:tapintapout/presentation/pages/selectRoute.dart';
import 'package:tapintapout/routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some initialization
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the home screen after 3 seconds
      dataController.filipayCards.isEmpty && tapinController.tapin.isEmpty
          ? Get.off(LoginPage())
          //  Routes.LOGIN
          : dataController.selectedRoute.value == null
              // ? Routes.ROUTE_DETAIL
              ? Get.off(SelectRoutePage())
              // : Routes.HOME;
              : Get.off(HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Image.asset(
          'assets/filipaylogo.png', // Path to your logo image
          width: 200, // Set the desired width
          height: 200, // Set the desired height
          fit: BoxFit.contain, // Adjust the fit of the image
        ),
      ),
    );
  }
}
