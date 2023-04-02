// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_coffee.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteCoffeeAdapter extends TypeAdapter<FavoriteCoffee> {
  @override
  final int typeId = 0;

  @override
  FavoriteCoffee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteCoffee(
      id: fields[1] as String,
      url: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteCoffee obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteCoffeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
