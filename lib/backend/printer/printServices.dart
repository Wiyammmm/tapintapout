import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as blue;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tapintapout/core/utils.dart';

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

  printTransactionReceipt(Map<String, dynamic> item) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            breakString(
                "${coopInfoController.coopInfo.value!.cooperativeName}", 24),
            1,
            1);
        bluetooth.printCustom("POWERED BY: FILIPAY", 1, 1);

        bluetooth.printLeftRight("TICKET#:", "${item['ticketNumber']}", 1);
        bluetooth.printLeftRight("FARE:", "${item['fare']}", 1);
        bluetooth.printLeftRight("DISCOUNT:", "${item['discount']}", 1);
        bluetooth.printCustom("TOTAL AMOUNT", 2, 1);
        bluetooth.printCustom("${item['amount']}", 2, 1);
        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printLeftRight("KM RUN:", "${item['kmrun']}", 1);
        bluetooth.printLeftRight("ORIGIN:", "${item['origin']}", 1);
        bluetooth.printLeftRight("DESTINATION:", "${item['destination']}", 1);

        bluetooth.printCustom("- - - - - - - - - - - - - - -", 1, 1);
        bluetooth.printCustom("NOT AN OFFICIAL RECEIPT", 1, 1);
        bluetooth.printNewLine();

        bluetooth.printNewLine();
      }
    });
  }

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
}
