import 'package:hive/hive.dart';

part 'endpoint_model.g.dart'; // This part is necessary for code generation

@HiveType(typeId: 2) // Ensure this typeId is unique
class EndpointModel extends HiveObject {
  @HiveField(0)
  String authenticationToken;

  @HiveField(1)
  String endpointName;

  @HiveField(2)
  bool isIncomingConnection;

  EndpointModel({
    required this.authenticationToken,
    required this.endpointName,
    required this.isIncomingConnection,
  });
}
