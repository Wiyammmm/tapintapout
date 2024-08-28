import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blue;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintServices {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  sample() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom("TEST", 1, 1);
        bluetooth.printCustom("TEST", 1, 1);
        bluetooth.printCustom("TEST", 1, 1);
        bluetooth.printCustom("TEST", 1, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  printSNLoadReceipt(String sNo, String amount, String receiverPrevBalance,
      String receiverNewBalance, String referenceNumber) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom("LOAD RECEIPT", 1, 1);
        bluetooth.printCustom("POWERED BY: FILIPAY", 1, 1);

        bluetooth.printLeftRight("SN", "$sNo", 1);
        bluetooth.printLeftRight("AMOUNT", "$amount", 1);
        bluetooth.printLeftRight("PREV BALANCE",
            "${double.parse(receiverPrevBalance).toStringAsFixed(2)}", 1);
        bluetooth.printLeftRight("NEW BALANCE",
            "${double.parse(receiverNewBalance).toStringAsFixed(2)}", 1);
        bluetooth.printLeftRight("reference#", "$referenceNumber", 1);
        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
        bluetooth.printNewLine();

        bluetooth.printNewLine();
      }
    });
  }

  printBalance(String amount, String sNo) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom("LOAD RECEIPT", 1, 1);
        bluetooth.printCustom("POWERED BY: FILIPAY", 1, 1);
        bluetooth.printLeftRight("SNO", "$sNo", 1);
        bluetooth.printLeftRight("AMOUNT", "$amount", 1);

        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
        bluetooth.printNewLine();

        bluetooth.printNewLine();
      }
    });
  }

  printTransactionReceipt(Map<String, dynamic> item) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom("SERVICE ECONOMY\nAPPLICATION INC.", 1, 1);
        bluetooth.printCustom("POWERED BY: FILIPAY", 1, 1);

        bluetooth.printLeftRight("TICKET#:", "${item['ticketNumber']}", 1);
        bluetooth.printLeftRight("AMOUNT:", "${item['amount']}", 1);
        bluetooth.printLeftRight("DISCOUNT:", "${item['discount']}", 1);
        bluetooth.printCustom("TOTAL AMOUNT", 2, 1);
        bluetooth.printCustom("${item['fare']}", 2, 1);
        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printLeftRight("KM RUN:", "${item['km_run']}", 1);
        bluetooth.printLeftRight("ORIGIN:", "${item['tapInStation']}", 1);
        bluetooth.printLeftRight("DESTINATION:", "${item['tapOutStation']}", 1);

        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
        bluetooth.printNewLine();

        bluetooth.printNewLine();
      }
    });
  }
}
