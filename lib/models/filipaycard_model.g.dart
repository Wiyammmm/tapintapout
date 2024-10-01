// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filipaycard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilipayCardModelAdapter extends TypeAdapter<FilipayCardModel> {
  @override
  final int typeId = 6;

  @override
  FilipayCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilipayCardModel(
      id: fields[0] as String,
      cardID: fields[1] as String,
      balance: fields[2] as double,
      sNo: fields[3] as String,
      cardType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FilipayCardModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardID)
      ..writeByte(2)
      ..write(obj.balance)
      ..writeByte(3)
      ..write(obj.sNo)
      ..writeByte(4)
      ..write(obj.cardType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilipayCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
