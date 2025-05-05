// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'economic_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EconomicEventAdapter extends TypeAdapter<EconomicEvent> {
  @override
  final int typeId = 1;

  @override
  EconomicEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EconomicEvent(
      title: fields[0] as String,
      date: fields[1] as DateTime,
      impact: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EconomicEvent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.impact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EconomicEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
