import 'package:hive/hive.dart';

part 'tapin_model.g.dart';

@HiveType(typeId: 4)
class TapinModel extends HiveObject {
  @HiveField(0)
  String cardId;

  @HiveField(1)
  String tapinStationId;

  @HiveField(2)
  String tapoutStationId;

  @HiveField(3)
  String tapinLat;

  @HiveField(4)
  String tapoutLat;

  @HiveField(5)
  String tapinLong;

  @HiveField(6)
  String tapoutLong;

  @HiveField(7)
  String status;

  @HiveField(8)
  String ticketNumber;

  @HiveField(9)
  String origin;

  @HiveField(10)
  String destination;

  @HiveField(11)
  double kmrun;

  @HiveField(12)
  double fare;

  @HiveField(13)
  double discount;

  @HiveField(14)
  double amount;

  @HiveField(15)
  String dateTime;

  TapinModel(
      {required this.cardId,
      required this.tapinStationId,
      required this.tapoutStationId,
      required this.tapinLat,
      required this.tapoutLat,
      required this.tapinLong,
      required this.tapoutLong,
      required this.status,
      required this.ticketNumber,
      required this.origin,
      required this.destination,
      required this.kmrun,
      required this.fare,
      required this.discount,
      required this.amount,
      required this.dateTime});
}
