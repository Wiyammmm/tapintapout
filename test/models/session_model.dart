import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 3)
class SessionModel extends HiveObject {
  @HiveField(0)
  String routeId;

  @HiveField(1)
  String lastStationId;

  SessionModel({required this.routeId, required this.lastStationId});
}
