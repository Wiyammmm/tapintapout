import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 3)
class SessionModel extends HiveObject {
  @HiveField(0)
  String routeId;

  @HiveField(1)
  String lastStationId;

  @HiveField(2)
  String targetStationId;

  @HiveField(3)
  bool isReversed;

  SessionModel(
      {required this.routeId,
      required this.lastStationId,
      required this.targetStationId,
      this.isReversed = false});
}