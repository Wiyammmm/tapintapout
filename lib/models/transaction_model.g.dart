// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 5;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      coopId: fields[0] as String,
      cardId: fields[1] as String,
      tapOutLat: fields[2] as String,
      tapOutLong: fields[3] as String,
      tapInLat: fields[4] as String,
      tapInLong: fields[5] as String,
      tapInStation: fields[6] as String,
      tapOutStation: fields[7] as String,
      km_run: fields[8] as double,
      amount: fields[9] as double,
      discount: fields[10] as double,
      fare: fields[11] as double,
      cardType: fields[12] as String,
      mop: fields[13] as String,
      status: fields[14] as String,
      maxfare: fields[15] as double,
      ticketNumber: fields[16] as String,
      vehicleNo: fields[17] as String,
      plateNumber: fields[18] as String,
      date: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.coopId)
      ..writeByte(1)
      ..write(obj.cardId)
      ..writeByte(2)
      ..write(obj.tapOutLat)
      ..writeByte(3)
      ..write(obj.tapOutLong)
      ..writeByte(4)
      ..write(obj.tapInLat)
      ..writeByte(5)
      ..write(obj.tapInLong)
      ..writeByte(6)
      ..write(obj.tapInStation)
      ..writeByte(7)
      ..write(obj.tapOutStation)
      ..writeByte(8)
      ..write(obj.km_run)
      ..writeByte(9)
      ..write(obj.amount)
      ..writeByte(10)
      ..write(obj.discount)
      ..writeByte(11)
      ..write(obj.fare)
      ..writeByte(12)
      ..write(obj.cardType)
      ..writeByte(13)
      ..write(obj.mop)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.maxfare)
      ..writeByte(16)
      ..write(obj.ticketNumber)
      ..writeByte(17)
      ..write(obj.vehicleNo)
      ..writeByte(18)
      ..write(obj.plateNumber)
      ..writeByte(19)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
