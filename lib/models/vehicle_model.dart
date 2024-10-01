import 'package:hive/hive.dart';

part 'vehicle_model.g.dart'; // This part is necessary for code generation

@HiveType(typeId: 9) // Ensure this typeId is unique
class VehicleModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String coopId;

  @HiveField(2)
  String vehicle_no;

  @HiveField(3)
  String plate_no;

  VehicleModel({
    required this.id,
    required this.coopId,
    required this.vehicle_no,
    required this.plate_no,
  });
}
