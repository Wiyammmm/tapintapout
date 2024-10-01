// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EndpointModelAdapter extends TypeAdapter<EndpointModel> {
  @override
  final int typeId = 2;

  @override
  EndpointModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EndpointModel(
      authenticationToken: fields[0] as String,
      endpointName: fields[1] as String,
      isIncomingConnection: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EndpointModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.authenticationToken)
      ..writeByte(1)
      ..write(obj.endpointName)
      ..writeByte(2)
      ..write(obj.isIncomingConnection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
