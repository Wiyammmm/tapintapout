import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 5)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String coopId;

  @HiveField(1)
  String cardId;

  @HiveField(2)
  String tapOutLat;

  @HiveField(3)
  String tapOutLong;

  @HiveField(4)
  String tapInLat;

  @HiveField(5)
  String tapInLong;

  @HiveField(6)
  String tapInStation;

  @HiveField(7)
  String tapOutStation;

  @HiveField(8)
  double km_run;

  @HiveField(9)
  double amount;

  @HiveField(10)
  double discount;

  @HiveField(11)
  double fare;

  @HiveField(12)
  String cardType;

  @HiveField(13)
  String mop;

  @HiveField(14)
  String status;

  @HiveField(15)
  double maxfare;

  @HiveField(16)
  String ticketNumber;

  @HiveField(17)
  String vehicleNo;

  @HiveField(18)
  String plateNumber;

  @HiveField(19)
  String routeId;

  @HiveField(20)
  String driverId;

  @HiveField(21)
  String date;

  TransactionModel(
      {required this.coopId,
      required this.cardId,
      required this.tapOutLat,
      required this.tapOutLong,
      required this.tapInLat,
      required this.tapInLong,
      required this.tapInStation,
      required this.tapOutStation,
      required this.km_run,
      required this.amount,
      required this.discount,
      required this.fare,
      required this.cardType,
      required this.mop,
      required this.status,
      required this.maxfare,
      required this.ticketNumber,
      required this.vehicleNo,
      required this.plateNumber,
      required this.routeId,
      required this.driverId,
      required this.date});
}
