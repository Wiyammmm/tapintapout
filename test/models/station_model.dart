import 'package:hive/hive.dart';

part 'station_model.g.dart';

@HiveType(typeId: 1)
class StationModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String coopId;

  @HiveField(2)
  double lat;

  @HiveField(3)
  double long;

  @HiveField(4)
  double radius;

  @HiveField(5)
  double km;

  @HiveField(6)
  String stationName;

  @HiveField(7)
  int stationNum;

  @HiveField(8)
  String routeId;

  StationModel({
    required this.id,
    required this.coopId,
    required this.lat,
    required this.long,
    required this.radius,
    required this.km,
    required this.stationName,
    required this.stationNum,
    required this.routeId,
  });
}
