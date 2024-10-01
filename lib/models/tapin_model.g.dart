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
      tapoutStationId: fields[2] as String,
      tapinLat: fields[3] as String,
      tapoutLat: fields[4] as String,
      tapinLong: fields[5] as String,
      tapoutLong: fields[6] as String,
      status: fields[7] as String,
      ticketNumber: fields[8] as String,
      origin: fields[9] as String,
      destination: fields[10] as String,
      kmrun: fields[11] as double,
      fare: fields[12] as double,
      discount: fields[13] as double,
      amount: fields[14] as double,
      dateTime: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TapinModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.tapinStationId)
      ..writeByte(2)
      ..write(obj.tapoutStationId)
      ..writeByte(3)
      ..write(obj.tapinLat)
      ..writeByte(4)
      ..write(obj.tapoutLat)
      ..writeByte(5)
      ..write(obj.tapinLong)
      ..writeByte(6)
      ..write(obj.tapoutLong)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.ticketNumber)
      ..writeByte(9)
      ..write(obj.origin)
      ..writeByte(10)
      ..write(obj.destination)
      ..writeByte(11)
      ..write(obj.kmrun)
      ..writeByte(12)
      ..write(obj.fare)
      ..writeByte(13)
      ..write(obj.discount)
      ..writeByte(14)
      ..write(obj.amount)
      ..writeByte(15)
      ..write(obj.dateTime);
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
