import 'package:hive/hive.dart';

part 'tapin_model.g.dart';

@HiveType(typeId: 4)
class TapinModel extends HiveObject {
  @HiveField(0)
  String cardId;

  @HiveField(1)
  String tapinStationId;

  TapinModel({required this.cardId, required this.tapinStationId});
}
