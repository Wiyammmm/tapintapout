// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationModelAdapter extends TypeAdapter<StationModel> {
  @override
  final int typeId = 1;

  @override
  StationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StationModel(
      id: fields[0] as String,
      coopId: fields[1] as String,
      lat: fields[2] as double,
      long: fields[3] as double,
      radius: fields[4] as double,
      km: fields[5] as double,
      stationName: fields[6] as String,
      stationNum: fields[7] as int,
      routeId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StationModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coopId)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.long)
      ..writeByte(4)
      ..write(obj.radius)
      ..writeByte(5)
      ..write(obj.km)
      ..writeByte(6)
      ..write(obj.stationName)
      ..writeByte(7)
      ..write(obj.stationNum)
      ..writeByte(8)
      ..write(obj.routeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
