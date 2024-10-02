// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionModelAdapter extends TypeAdapter<SessionModel> {
  @override
  final int typeId = 3;

  @override
  SessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionModel(
      routeId: fields[0] as String,
      lastStationId: fields[1] as String,
      targetStationId: fields[2] as String,
      vehicleId: fields[3] as String,
      isReversed: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.routeId)
      ..writeByte(1)
      ..write(obj.lastStationId)
      ..writeByte(2)
      ..write(obj.targetStationId)
      ..writeByte(3)
      ..write(obj.vehicleId)
      ..writeByte(4)
      ..write(obj.isReversed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
