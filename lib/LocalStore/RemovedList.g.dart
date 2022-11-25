// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RemovedList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemovedListAdapter extends TypeAdapter<RemovedList> {
  @override
  final int typeId = 1;

  @override
  RemovedList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RemovedList(
      name: fields[0] as String?,
      email: fields[1] as String?,
      phone: fields[2] as String?,
      password: fields[3] as String?,
      profilePic: fields[4] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, RemovedList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.profilePic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemovedListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
