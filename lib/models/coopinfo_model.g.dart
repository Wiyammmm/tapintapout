// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coopinfo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoopInfoModelAdapter extends TypeAdapter<CoopInfoModel> {
  @override
  final int typeId = 8;

  @override
  CoopInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoopInfoModel(
      id: fields[0] as String,
      cooperativeName: fields[1] as String,
      cooperativeCodeName: fields[2] as String,
      coopType: fields[3] as String,
      maximumBaggage: fields[4] as double,
      maximumFare: fields[5] as double,
      modeOfPayment: fields[6] as String,
      balance: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CoopInfoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cooperativeName)
      ..writeByte(2)
      ..write(obj.cooperativeCodeName)
      ..writeByte(3)
      ..write(obj.coopType)
      ..writeByte(4)
      ..write(obj.maximumBaggage)
      ..writeByte(5)
      ..write(obj.maximumFare)
      ..writeByte(6)
      ..write(obj.modeOfPayment)
      ..writeByte(7)
      ..write(obj.balance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoopInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
