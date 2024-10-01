import 'package:hive/hive.dart';

part 'filipaycard_model.g.dart'; // This part is necessary for code generation

@HiveType(typeId: 6) // Ensure this typeId is unique
class FilipayCardModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String cardID;

  @HiveField(2)
  double balance;

  @HiveField(3)
  String sNo;

  @HiveField(4)
  String cardType;

  FilipayCardModel({
    required this.id,
    required this.cardID,
    required this.balance,
    required this.sNo,
    required this.cardType,
  });
}
