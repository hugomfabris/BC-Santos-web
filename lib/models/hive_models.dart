import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 0)
class Inspection extends HiveObject {
  @HiveField(0)
  late String? id;

  @HiveField(1)
  late String? inspector;

  @HiveField(2)
  late String? inspectionType;

  @HiveField(3)
  late DateTime inspectionDate;

  @HiveField(4)
  late int? anotations;

  @HiveField(5)
  late String? checklist;

  @HiveField(6)
  late String? certificate;

  @HiveField(7)
  late String? name;

  @HiveField(8)
  late String? observations;
}

@HiveType(typeId: 1)
class Plan extends HiveObject {
  @HiveField(0)
  late String? id;

  @HiveField(1)
  late String? planPath;

}

