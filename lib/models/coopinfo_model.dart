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
  String coopType;

  @HiveField(4)
  double maximumBaggage;

  @HiveField(5)
  double maximumFare;

  @HiveField(6)
  String modeOfPayment;

  @HiveField(7)
  double balance;

  CoopInfoModel(
      {required this.id,
      required this.cooperativeName,
      required this.cooperativeCodeName,
      required this.coopType,
      required this.maximumBaggage,
      required this.maximumFare,
      required this.modeOfPayment,
      required this.balance});
}
