// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteModelAdapter extends TypeAdapter<RouteModel> {
  @override
  final int typeId = 0;

  @override
  RouteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteModel(
      id: fields[0] as String,
      coopId: fields[1] as String,
      origin: fields[2] as String,
      destination: fields[3] as String,
      minimum_fare: fields[4] as double,
      maximumFare: fields[5] as double,
      discount: fields[6] as int,
      pricePerKM: fields[7] as double,
      first_km: fields[8] as double,
      routeLoop: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RouteModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coopId)
      ..writeByte(2)
      ..write(obj.origin)
      ..writeByte(3)
      ..write(obj.destination)
      ..writeByte(4)
      ..write(obj.minimum_fare)
      ..writeByte(5)
      ..write(obj.maximumFare)
      ..writeByte(6)
      ..write(obj.discount)
      ..writeByte(7)
      ..write(obj.pricePerKM)
      ..writeByte(8)
      ..write(obj.first_km)
      ..writeByte(9)
      ..write(obj.routeLoop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
