import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blue;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:tapintapout/core/utils.dart';

class PrintServices extends GetxService {
  int fontSize = 23;
  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // sample() {
  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected == true) {
  //       bluetooth.printCustom("TEST", 1, 1);
  //       bluetooth.printCustom("TEST", 1, 1);
  //       bluetooth.printCustom("TEST", 1, 1);
  //       bluetooth.printCustom("TEST", 1, 1);
  //       bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //       bluetooth.printNewLine();
  //     }
  //   });
  // }

  sunmiSample() async {
    await SunmiPrinter.startTransactionPrint(true);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT); // Right align
    await SunmiPrinter.printText('Align right');

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT); // Left align
    await SunmiPrinter.printText('Align left');

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
    await SunmiPrinter.printText('Align center');

    await SunmiPrinter.lineWrap(2); // Jump 2 lines

    await SunmiPrinter.setFontSize(SunmiFontSize.XL); // Set font to very large
    await SunmiPrinter.printText('Very Large font!');
    await SunmiPrinter.resetFontSize(); // Reset font to medium size

    await SunmiPrinter.setCustomFontSize(fontSize); // SET CUSTOM FONT 12
    await SunmiPrinter.bold();
    await SunmiPrinter.printText('Custom font size!!!');
    await SunmiPrinter.resetFontSize(); // Reset font to medium size

    await SunmiPrinter.lineWrap(4);
    await SunmiPrinter.submitTransactionPrint(); // SUBMIT and cut paper
    await SunmiPrinter.exitTransactionPrint(true); // Close the transaction
  }

  printTransactionReceipt(Map<String, dynamic> item) async {
    if (permissionController.isPrinter.value) {
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER); // Center align
      await SunmiPrinter.bold();
      await SunmiPrinter.setCustomFontSize(fontSize);
      await SunmiPrinter.printText(breakString(
          "${coopInfoController.coopInfo.value!.cooperativeName}", 24));
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.bold();
      await SunmiPrinter.setCustomFontSize(fontSize);
      await SunmiPrinter.printText("POWERED BY: FILIPAY");
      await printLeftRight("TICKET#: ", item['ticketNumber']);
      await printLeftRight("DATE:    ", item['date']);
      await printLeftRight("FARE:    ", item['fare']);
      await printLeftRight("DISCOUNT:", item['discount']);

      await SunmiPrinter.bold();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.setCustomFontSize(30);

      await SunmiPrinter.printText("TOTAL AMOUNT");
      await SunmiPrinter.bold();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.setCustomFontSize(30);

      await SunmiPrinter.printText("${item['amount']}");

      // await SunmiPrinter.line(ch: "-", len: 31);
      await SunmiPrinter.printText("- - - - - - - - - - - - - - - -");
      await printLeftRight("PLATE#:  ", item['plateNumber']);
      await printLeftRight("KM RUN:  ", item['kmrun']);
      await printLeftRight("ORIGIN:  ", item['origin']);
      await printLeftRight("DESTINATION:", item['destination'], 19);

      await SunmiPrinter.printText("- - - - - - - - - - - - - - - -");
      // await SunmiPrinter.line(ch: "-", len: 31);
      await SunmiPrinter.bold();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.setCustomFontSize(fontSize);

      await SunmiPrinter.printText("NOT AN OFFICIAL RECEIPT");
      await SunmiPrinter.lineWrap(3);
      await SunmiPrinter.cut();

      // bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
      // bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
      // bluetooth.printNewLine();

      // bluetooth.printNewLine();
    }
  }

  Future<void> printLeftRight(String label, String value,
      [int maxright = 22]) async {
    await SunmiPrinter.bold();
    await SunmiPrinter.setCustomFontSize(fontSize);
    await SunmiPrinter.printText('$label${newText(value, maxright)}');
  }
  // printTransactionReceipt(Map<String, dynamic> item) {
  //   bluetooth.isConnected.then((isConnected) {
  //     if (isConnected == true) {
  //       bluetooth.printCustom(
  //           breakString(
  //               "${coopInfoController.coopInfo.value!.cooperativeName}", 24),
  //           1,
  //           1);
  //       bluetooth.printCustom("POWERED BY: FILIPAY", 1, 1);

  //       bluetooth.printLeftRight("TICKET#:", "${item['ticketNumber']}", 1);
  //       bluetooth.printLeftRight("FARE:", "${item['fare']}", 1);
  //       bluetooth.printLeftRight("DISCOUNT:", "${item['discount']}", 1);
  //       bluetooth.printCustom("TOTAL AMOUNT", 2, 1);
  //       bluetooth.printCustom("${item['amount']}", 2, 1);
  //       bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
  //       bluetooth.printLeftRight("KM RUN:", "${item['kmrun']}", 1);
  //       bluetooth.printLeftRight("ORIGIN:", "${item['origin']}", 1);
  //       bluetooth.printLeftRight("DESTINATION:", "${item['destination']}", 1);

  //       bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
  //       bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
  //       bluetooth.printNewLine();

  //       bluetooth.printNewLine();
  //     }
  //   });
  // }

  String breakString(String input, int maxLength) {
    List<String> words = input.split(' ');

    String firstLine = '';
    String secondLine = '';

    for (int i = 0; i < words.length; i++) {
      String word = words[i];

      if ((firstLine.length + 1 + word.length) <= maxLength) {
        // Add the word to the first line
        firstLine += (firstLine == "" ? '' : ' ') + word;
      } else if (secondLine == "") {
        // If the second line is empty, add the word to it
        secondLine += word;
      } else {
        // Truncate the word if it exceeds the maxLength
        int remainingSpace = maxLength - secondLine.length - 1;
        secondLine += ' ' +
            (word.length > remainingSpace
                ? word.substring(0, remainingSpace) + '..'
                : word);
        break;
      }
    }
    // Return the concatenated lines
    if (secondLine.trim() == "") {
      return "$firstLine";
    } else {
      return '$firstLine\n$secondLine';
    }
  }

  String newText(String text, [int maxright = 22]) {
    if (text.length > maxright) {
      // Trim the text to 20 characters and add '..'
      return text.substring(0, maxright - 2) + '..';
    } else if (text.length < maxright) {
      // Add spaces at the start to make the text length 22
      return text.padLeft(maxright);
    }
    return text;
  }
}
