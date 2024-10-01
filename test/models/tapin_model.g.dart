// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tapin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TapinModelAdapter extends TypeAdapter<TapinModel> {
  @override
  final int typeId = 4;

  @override
  TapinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TapinModel(
      cardId: fields[0] as String,
      tapinStationId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TapinModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.tapinStationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TapinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
