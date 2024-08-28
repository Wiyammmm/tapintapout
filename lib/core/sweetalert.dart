import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';

class SweetAlertUtils {
  static void showConfirmationDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
    required String thisTitle,
    String title = "Are you sure?",
    String subtitle = "Do you want to proceed?",
  }) {
    ArtSweetAlert.show(
        context: context,
        barrierDismissible: false,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: "Are you sure?",
            text: "Route: $thisTitle",
            confirmButtonText: "Yes",
            type: ArtSweetAlertType.warning,
            onConfirm: onConfirm));
  }

  static void showErrorDialog(
    BuildContext context, {
    required String thisTitle,
    String title = "Something went Wrong",
  }) {
    ArtSweetAlert.show(
        context: context,
        barrierDismissible: false,
        artDialogArgs: ArtDialogArgs(
          title: title,
          text: thisTitle,
          type: ArtSweetAlertType.danger,
        ));
  }
}
