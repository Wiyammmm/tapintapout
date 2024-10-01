import 'package:hive/hive.dart';

part 'coopinfo_model.g.dart';

@HiveType(typeId: 8)
class CoopInfoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String cooperativeName;

  @HiveField(2)
  String cooperativeCodeName;

  @HiveField(3)
  double minimum_fare;

  @HiveField(4)
  double pricePerKM;

  @HiveField(5)
  bool isNumeric;

  @HiveField(6)
  String coopType;

  @HiveField(7)
  double maximumBaggage;

  @HiveField(8)
  double maximumFare;

  @HiveField(9)
  String modeOfPayment;

  @HiveField(10)
  double balance;

  CoopInfoModel(
      {required this.id,
      required this.cooperativeName,
      required this.cooperativeCodeName,
      required this.minimum_fare,
      required this.pricePerKM,
      required this.isNumeric,
      required this.coopType,
      required this.maximumBaggage,
      required this.maximumFare,
      required this.modeOfPayment,
      required this.balance});
}
