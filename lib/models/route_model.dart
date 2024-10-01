import 'package:hive/hive.dart';

part 'route_model.g.dart';

@HiveType(typeId: 0)
class RouteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String coopId;

  @HiveField(2)
  String origin;

  @HiveField(3)
  String destination;

  @HiveField(4)
  double minimum_fare;

  @HiveField(5)
  double maximumFare;

  @HiveField(6)
  int discount;

  @HiveField(7)
  double pricePerKM;

  @HiveField(8)
  double first_km;

  @HiveField(9)
  bool routeLoop;

  RouteModel({
    required this.id,
    required this.coopId,
    required this.origin,
    required this.destination,
    required this.minimum_fare,
    required this.maximumFare,
    required this.discount,
    required this.pricePerKM,
    required this.first_km,
    required this.routeLoop,
  });
}
