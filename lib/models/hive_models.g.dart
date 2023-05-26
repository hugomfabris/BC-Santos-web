// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionAdapter extends TypeAdapter<Inspection> {
  @override
  final int typeId = 0;

  @override
  Inspection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Inspection()
      ..id = fields[0] as String?
      ..inspector = fields[1] as String?
      ..inspectionType = fields[2] as String?
      ..inspectionDate = fields[3] as DateTime
      ..anotations = fields[4] as int?
      ..checklist = fields[5] as String?
      ..certificate = fields[6] as String?
      ..name = fields[7] as String?
      ..observations = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, Inspection obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inspector)
      ..writeByte(2)
      ..write(obj.inspectionType)
      ..writeByte(3)
      ..write(obj.inspectionDate)
      ..writeByte(4)
      ..write(obj.anotations)
      ..writeByte(5)
      ..write(obj.checklist)
      ..writeByte(6)
      ..write(obj.certificate)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.observations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlanAdapter extends TypeAdapter<Plan> {
  @override
  final int typeId = 1;

  @override
  Plan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plan()
      ..id = fields[0] as String?
      ..planPath = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, Plan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
