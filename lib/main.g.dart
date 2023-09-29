// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMCAdapter extends TypeAdapter<IMC> {
  @override
  final int typeId = 0;

  @override
  IMC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMC(
      fields[0] as String,
      fields[1] as int,
      fields[2] as double,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IMC obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.idade)
      ..writeByte(2)
      ..write(obj.altura)
      ..writeByte(3)
      ..write(obj.peso);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
