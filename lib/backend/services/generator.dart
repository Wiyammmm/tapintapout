import 'package:tapintapout/core/utils.dart';

class GeneratorServices {
  String generateTicketNo() {
    DateTime now = DateTime.now();
    String formattedMonth = now.month.toString().padLeft(2, '0');
    String formattedDay = now.day.toString().padLeft(2, '0');
    String formattedYear = now.year
        .toString()
        .substring(2)
        .padLeft(2, '0'); // Extract last two digits and pad to 2 digits
    int hours = now.hour;
    int minutes = now.minute;
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String currentDate =
        "$formattedMonth$formattedDay$formattedYear$formattedHours$formattedMinutes";
    String ticketNumber = '$currentDate-${tapinController.tapin.length + 1}';
    return ticketNumber;
  }
}
