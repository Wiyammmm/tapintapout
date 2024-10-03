import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tapintapout/controllers/transaction_controller.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/models/tapin_model.dart';
import 'package:tapintapout/presentation/pages/homePage.dart';
import 'package:tapintapout/presentation/widgets/base.dart';

class TransactionPageController extends GetxController {
  var isTapin = true.obs;

  void changeTapView(bool newValue) {
    isTapin.value = newValue;
    // isTapin.refresh();
    print('istapin: $isTapin');
  }
}

class TransactionPage extends StatelessWidget {
  TransactionPage({super.key});
  final TransactionPageController transactionPageController =
      Get.put(TransactionPageController());
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Column(
      children: [
        AppBarWidget(context: context),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  controller.close();
                  Get.off(HomePage());
                },
                icon: Icon(Icons.arrow_back)),
            const Text(
              'Transactions',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        Divider(),
        Obx(() {
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionPageController.changeTapView(true),
                  child: Container(
                    decoration: BoxDecoration(
                        color: transactionPageController.isTapin.value
                            ? Colors.blueAccent
                            : Colors.grey[200]),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Tap In',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: transactionPageController.isTapin.value
                                  ? Colors.white
                                  : Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionPageController.changeTapView(false),
                  child: Container(
                    decoration: BoxDecoration(
                        color: !transactionPageController.isTapin.value
                            ? Colors.blueAccent
                            : Colors.grey[200]),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Tap Out',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: !transactionPageController.isTapin.value
                                  ? Colors.white
                                  : Colors.lightBlue),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
        const SizedBox(
          height: 10,
        ),
        Obx(() {
          if (tapinController.tapin
              .where((tapin) => transactionPageController.isTapin.value
                  ? tapin.destination == ''
                  : tapin.destination != '') // Filter condition
              .toList()
              .isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                const Center(
                  child: Text(
                    'No Transaction',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }

          return Expanded(
            child: PagedListView<int, TapinModel>(
              pagingController: controller.pagingController,
              builderDelegate: PagedChildBuilderDelegate<TapinModel>(
                  itemBuilder: (context, transaction, index) {
                // var reversedTapin = tapinController.tapin
                //     .where((tapin) => transactionPageController.isTapin.value
                //         ? tapin.destination == ''
                //         : tapin.destination != '') // Filter condition
                //     .toList()
                //     .reversed
                //     .toList();

                if (transactionPageController.isTapin.value) {
                  if (transaction.destination != '') {
                    return SizedBox();
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    children: [
                      TransactionDataWidget(
                        label: 'Ticket Number',
                        value: '${transaction.ticketNumber}',
                      ),
                      TransactionDataWidget(
                        label: 'Date & Time',
                        value: '${transaction.dateTime}',
                      ),
                      TransactionDataWidget(
                        label: 'Origin',
                        value: '${transaction.origin}',
                      ),
                      if (!transactionPageController.isTapin.value) ...[
                        TransactionDataWidget(
                          label: 'Destination',
                          value: '${transaction.destination}',
                        ),
                        TransactionDataWidget(
                          label: 'Km run',
                          value: '${transaction.kmrun.toStringAsFixed(2)}',
                        ),
                        TransactionDataWidget(
                          label: 'Fare',
                          value: '${transaction.fare.toStringAsFixed(2)}',
                        ),
                        TransactionDataWidget(
                          label: 'Discount',
                          value: '${transaction.discount.toStringAsFixed(2)}',
                        ),
                      ],
                      TransactionDataWidget(
                        label: 'Total Amount',
                        value: '${transaction.amount.toStringAsFixed(2)}',
                      ),
                      Divider(),
                    ],
                  ),
                );
              }),
            ),

            // ListView.builder(
            //     itemCount: tapinController.tapin
            //         .where((tapin) => transactionPageController.isTapin.value
            //             ? tapin.destination == ''
            //             : tapin.destination !=
            //                 '') // Filter items where destination is empty
            //         .length,
            //     itemBuilder: (context, index) {
            //       var reversedTapin = tapinController.tapin
            //           .where((tapin) =>
            //               transactionPageController.isTapin.value
            //                   ? tapin.destination == ''
            //                   : tapin.destination != '') // Filter condition
            //           .toList()
            //           .reversed
            //           .toList();

            //       return Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         child: Wrap(
            //           children: [
            //             TransactionDataWidget(
            //               label: 'Ticket Number',
            //               value: '${reversedTapin[index].ticketNumber}',
            //             ),
            //             TransactionDataWidget(
            //               label: 'Date & Time',
            //               value: '${reversedTapin[index].dateTime}',
            //             ),
            //             TransactionDataWidget(
            //               label: 'Origin',
            //               value: '${reversedTapin[index].origin}',
            //             ),
            //             if (!transactionPageController.isTapin.value) ...[
            //               TransactionDataWidget(
            //                 label: 'Destination',
            //                 value: '${reversedTapin[index].destination}',
            //               ),
            //               TransactionDataWidget(
            //                 label: 'Km run',
            //                 value:
            //                     '${reversedTapin[index].kmrun.toStringAsFixed(2)}',
            //               ),
            //               TransactionDataWidget(
            //                 label: 'Fare',
            //                 value:
            //                     '${reversedTapin[index].fare.toStringAsFixed(2)}',
            //               ),
            //               TransactionDataWidget(
            //                 label: 'Discount',
            //                 value:
            //                     '${reversedTapin[index].discount.toStringAsFixed(2)}',
            //               ),
            //             ],
            //             TransactionDataWidget(
            //               label: 'Total Amount',
            //               value:
            //                   '${reversedTapin[index].amount.toStringAsFixed(2)}',
            //             ),
            //             Divider(),
            //           ],
            //         ),
            //       );
            //     })
          );
        })
      ],
    ));
  }
}

class TransactionDataWidget extends StatelessWidget {
  const TransactionDataWidget(
      {super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: '),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue),
        )
      ],
    );
  }
}
