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
      minimum_fare: fields[3] as double,
      pricePerKM: fields[4] as double,
      isNumeric: fields[5] as bool,
      coopType: fields[6] as String,
      maximumBaggage: fields[7] as double,
      maximumFare: fields[8] as double,
      modeOfPayment: fields[9] as String,
      balance: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CoopInfoModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cooperativeName)
      ..writeByte(2)
      ..write(obj.cooperativeCodeName)
      ..writeByte(3)
      ..write(obj.minimum_fare)
      ..writeByte(4)
      ..write(obj.pricePerKM)
      ..writeByte(5)
      ..write(obj.isNumeric)
      ..writeByte(6)
      ..write(obj.coopType)
      ..writeByte(7)
      ..write(obj.maximumBaggage)
      ..writeByte(8)
      ..write(obj.maximumFare)
      ..writeByte(9)
      ..write(obj.modeOfPayment)
      ..writeByte(10)
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
