import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapintapout/core/sweetalert.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/presentation/pages/transactionPage.dart';
import 'package:tapintapout/presentation/widgets/base.dart';

class UnsyncPage extends StatelessWidget {
  const UnsyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncing'),
        centerTitle: true,
      ),
      floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ElevatedButton(
              onPressed: () {
                SweetAlertUtils.showInformationDialog(context,
                    title: 'Internet',
                    thisTitle:
                        "Just turn on your internet connection and wait to sync all data",
                    onConfirm: () {
                  Navigator.of(context).pop();
                });
              },
              child: const Text(
                'SYNC',
                style: TextStyle(fontSize: 25),
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (deviceInfoService.transactionResponse.value != "") {
            print('transactionResponse.value not empty');

            Future.delayed(const Duration(seconds: 3), () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(deviceInfoService.transactionResponse.value),
                  duration: Duration(seconds: 3),
                ));
              }
            });
          }

          if (tapoutController.transaction.isEmpty) {
            return Column(
              children: [
                Center(
                  child: Text('No Unsync Data'),
                )
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: tapoutController.transaction.length,
                      itemBuilder: (context, index) {
                        var transaction = tapoutController.transaction[index];
                        return Wrap(
                          children: [
                            TransactionDataWidget(
                                label: 'Ticket Number',
                                value: '${transaction.ticketNumber}'),
                            TransactionDataWidget(
                                label: 'Status',
                                value: '${transaction.status}'),
                            Divider()
                          ],
                        );
                      }))
            ],
          );
        }),
      )),
    );
  }
}
