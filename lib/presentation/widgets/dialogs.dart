import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tapintapout/backend/printer/printerController.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/presentation/pages/loginPage.dart';

class DialogUtils {
  static Future<void> showLogout(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final PasswordController passwordControllerGetX =
        Get.put(PasswordController());
    passwordControllerGetX.errorMessage.value = null;
    TextEditingController passwordController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Enter Password to Logout'),
                    Obx(() => TextFormField(
                          controller: passwordController,
                          obscureText: passwordControllerGetX.isObscured.value,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordControllerGetX.isObscured.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  passwordControllerGetX.isObscured
                                      .toggle(); // Toggle visibility
                                },
                              ),
                              errorText:
                                  passwordControllerGetX.errorMessage.value),
                          onChanged: (value) {
                            print('onchanged');
                            passwordControllerGetX.errorMessage.value = null;
                            passwordControllerGetX.errorMessage.refresh();
                          },
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (passwordController.text == null ||
                              passwordController.text.isEmpty) {
                            passwordControllerGetX.errorMessage.value =
                                'Please enter your password';
                          }
                          bool isMatch = BCrypt.checkpw(passwordController.text,
                              userInfoController.userInfo.value!.password);
                          if (!isMatch) {
                            passwordControllerGetX.errorMessage.value =
                                'Wrong password';
                          } else {
                            print('success');
                            passwordControllerGetX.errorMessage.value = null;
                            await processServices.logoutProcess(context);
                          }
                        },
                        child: Text('VERIFY'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showTapin(
      BuildContext context, Function onConfirm, double fare) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/filipaylogobanner.png',
            width: 70,
            height: 70,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Your Traveled Fare is ${fare.toStringAsFixed(2)}'),
                  Text(
                    'WELCOME!\nHAVE A SAFE RIDE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) => onConfirm);
  }

  Future<void> showTapout(BuildContext context, VoidCallback onConfirm,
      Map<String, dynamic> item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/filipaylogobanner.png',
            width: 70,
            height: 70,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      'Your Traveled Fare is ${double.parse(item['remainingBalance'].toString()).toStringAsFixed(2)}'),
                  Text(
                      'We had refund -${double.parse(item['refund'].toString()).toStringAsFixed(2)}'),
                  Divider(),
                  Text(
                      'Remaining Balance: ${double.parse('${item['remainingBalance']}').toStringAsFixed(2)}'),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffd9d9d9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Traveled Distance'),
                              Text('${item['kmRun']}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Traveled Fare'),
                              Text(
                                  '${double.parse(item['fare'].toString()).toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount'),
                              Text(
                                  '${double.parse(item['discount'].toString()).toStringAsFixed(2)}'),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) => onConfirm);
  }

  void showLoadingDialog(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please wait...',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showFetchingDataDialog(BuildContext context) async {
    dataController.fetchAndStoreData();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Please wait...',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          content: Obx(() {
            if (dataController.errorPrompt.isNotEmpty) {
              print('errorPrompt not empty');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.of(Get.context!).canPop()) {
                  Navigator.of(Get.context!)
                      .pop(); // This will close the dialog if it's open
                } else {
                  print("No active dialog to close.");
                }
                SweetAlertUtils.showErrorDialog(context,
                    title: dataController.errorPrompt.value['title'],
                    thisTitle: dataController.errorPrompt.value['label'],
                    onConfirm: () {
                  Navigator.of(Get.context!).pop();
                  dataController.fetchAndStoreData();
                });
              });
            }
            if (!dataController.isLoading.value &&
                dataController.errorPrompt.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.of(Get.context!).canPop()) {
                  Navigator.of(Get.context!).pop();
                  SweetAlertUtils.showSuccessDialog(context,
                      title: 'Re-Fetch Data',
                      thisTitle: 'Successfully Fetch!', onConfirm: () {
                    Navigator.of(Get.context!).pop();
                  });
                } else {
                  print("No active dialog to close.");
                }
              });
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('${dataController.progressText.value}...'),
                    Text(
                        '${(dataController.progress.value * 100).toStringAsFixed(0)}%')

                    // Text(
                    //     '${dataController.progressText.value}... ${(dataController.progress.value * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future<void> showPermissionDialogs(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'PERMISSIONS',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          content: Obx(() {
            bool isLocationPermission =
                permissionController.locationPermission.value ==
                    LocationPermission.denied;

            bool isStoragePermission =
                permissionController.storagePermission.value ==
                    PermissionStatus.denied;
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                // direction: Axis.vertical,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PermisionButtonWidget(
                      label: 'Location',
                      isPermission: isLocationPermission,
                      onPressed: () async {
                        await permissionController.requestLocationPermission();
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  PermisionButtonWidget(
                      label: 'Printer',
                      // isPermission: !printerController.connected.value,
                      isPermission: !permissionController.isPrinter.value,
                      onPressed: () async {
                        // await printerController.connectToPrinter();
                        await permissionController.isSunmiPrinterBind();
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  PermisionButtonWidget(
                      label: 'Storage',
                      isPermission: isStoragePermission,
                      onPressed: () async {
                        await permissionController.requestStoragePermission();
                      }),

                  // Text(
                  //     '${dataController.progressText.value}... ${(dataController.progress.value * 100).toStringAsFixed(0)}%'),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class PermisionButtonWidget extends StatelessWidget {
  const PermisionButtonWidget(
      {super.key,
      required this.label,
      required this.isPermission,
      required this.onPressed});
  final String label;
  final bool isPermission;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Icon(
                isPermission
                    ? Icons.cancel_outlined
                    : Icons.check_circle_outline,
                color: isPermission ? Colors.red : Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
