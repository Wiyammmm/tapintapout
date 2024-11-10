import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapintapout/controllers/auth_controller.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/presentation/pages/selectRoute.dart';

import 'package:tapintapout/presentation/widgets/base.dart';

class PasswordController extends GetxController {
  var isObscured = true.obs; // Observable for toggling password visibility
  var errorMessage = Rx<String?>(null);
}

class LoginPage extends StatelessWidget {
  final PasswordController passwordControllerGetX =
      Get.put(PasswordController());
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // const LoginPage({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Email Validator
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"; // RegEx for email validation
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Submit Function
  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      authController.login(
        emailController.text,
        passwordController.text,
      );
      // If the form is valid, display a success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Form submitted successfully!')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BasePage(child: Obx(() {
        bool isLocationPermission =
            permissionController.locationPermission.value ==
                LocationPermission.denied;

        bool? isBluetoothPermission = permissionController.isPrinter.value;

        bool isStoragePermission =
            permissionController.storagePermission.value ==
                PermissionStatus.denied;
        print('isBluetoothPermission: $isBluetoothPermission');
        print('isLocationPermission: $isLocationPermission');
        print('isStoragePermission: $isStoragePermission');
        if (isLocationPermission ||
            !isBluetoothPermission ||
            isStoragePermission) {
          print('go permission dialog');
          if (Navigator.canPop(context)) {
            print('navigator pop?');
            Navigator.pop(context);
          }
          print(
              'permissionController.locationPermission.value: ${permissionController.locationPermission.value}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            dialogUtils.showPermissionDialogs(context);
          });
        } else {
          if (Navigator.canPop(context)) {
            print('navigator pop?');
            Navigator.pop(context);
          }
        }

        if (authController.isLoading.value) {
          if (Navigator.canPop(context)) {
            print('navigator pop?');
            Navigator.pop(context);
            print('navigator yes pop');
          }
          Future.delayed(Duration.zero, () {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(child: Text('Logging in')),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Please wait...')],
                  ),
                );
              },
            );
          });
        } else {
          if (!authController.isLoading.value &&
              authController.errorPrompt.isNotEmpty) {
            if (Navigator.canPop(context)) {
              print('navigator pop?');
              Navigator.pop(context);
              print('navigator yes pop');
            }
            Future.delayed(Duration.zero, () {
              print('login show dialog');
              if (authController.errorPrompt.isNotEmpty) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    print('error prompt: ${authController.errorPrompt}');
                    return AlertDialog(
                      title: Center(
                          child: FittedBox(
                              child: Text(
                                  '${authController.errorPrompt['title']}'))),
                      content: Wrap(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${authController.errorPrompt['label']}')
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  authController.errorPrompt.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK')),
                          )
                        ],
                      ),
                    );
                  },
                );
                // .then((value) {
                //   authController.errorPrompt.clear();
                // });
              }
            });
          }
        }

        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/bg red-blue.png',
                fit: BoxFit.cover,
                // Adjust the height as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/filipaylogo.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: emailController,
                              validator: _emailValidator,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                                controller: passwordController,
                                obscureText:
                                    passwordControllerGetX.isObscured.value,
                                decoration: InputDecoration(
                                  suffixIcon: Obx(() => IconButton(
                                        icon: Icon(
                                          passwordControllerGetX
                                                  .isObscured.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          passwordControllerGetX.isObscured
                                              .toggle(); // Toggle visibility
                                        },
                                      )),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => _submitForm(context),

                            // {

                            //   // Navigator.pushReplacement(
                            //   //   context,
                            //   //   MaterialPageRoute(
                            //   //       builder: (context) => SelectRoutePage()),
                            //   // );
                            // },
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )))
                  ],
                ),
              ),
            ),
          ],
        );
      })),
    );
  }
}
