// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 0;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address()
      ..firstName = fields[0] as String
      ..lastName = fields[1] as String
      ..city = fields[2] as String
      ..email = fields[3] as String
      ..phoneNumber = fields[4] as String
      ..currentAddress = fields[5] as bool
      ..towns = fields[6] as String
      ..region = fields[7] as String
      ..price = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.currentAddress)
      ..writeByte(6)
      ..write(obj.towns)
      ..writeByte(7)
      ..write(obj.region)
      ..writeByte(8)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
