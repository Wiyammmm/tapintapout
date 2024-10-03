import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tapintapout/core/utils.dart';
import 'package:tapintapout/presentation/pages/transactionPage.dart';

import '../models/tapin_model.dart';

class TransactionController extends GetxController {
  static const int _pageSize = 5;
  final PagingController<int, TapinModel> pagingController =
      PagingController(firstPageKey: 0);
  final TransactionPageController transactionPageController =
      Get.put(TransactionPageController());
  @override
  void onInit() {
    super.onInit();
    print('TransactionController init');
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  Future<void> fetchPage(int pageKey) async {
    print('_fetchPage pageKey: $pageKey');
    try {
      // Fetch data (here from a sample list, replace with actual API or data source)
      List<TapinModel> transactionList =
          await fetchTransactionsFromList(pageKey, _pageSize);

      // transactionList = transactionList.reversed.toList();
      final isLastPage = transactionList.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(transactionList);
      } else {
        final nextPageKey = pageKey + transactionList.length;
        pagingController.appendPage(transactionList, nextPageKey);
      }
    } catch (error) {
      print('fetchPage error: $error');
      // pagingController.error = error;
    }
  }

  Future<List<TapinModel>> fetchTransactionsFromList(
      int pageKey, int pageSize) async {
    // Example list of TapinModel (replace with actual data)
    List<TapinModel> allTransactions = tapinController.tapin.reversed.toList();
    print(
        'fetchTransactionsFromList: ${allTransactions.skip(pageKey).take(pageSize).toList()}');

    // Simulating pagination
    return allTransactions.skip(pageKey).take(pageSize).toList();
  }

  Future<void> close() async {
    pagingController.dispose();
  }
}
