import 'package:cloud_firestore/cloud_firestore.dart';

class Inspection {

  Inspection({
    this.id,
    this.shipName,
    this.inspector,
    this.inspectionType,
    this.inspectionDate,
    this.anotations,
    this.checklist,
    this.certificate,
    this.observations,
  });

  late String? id;
  late String? shipName;
  late String? inspector;
  late String? inspectionType;
  late DateTime? inspectionDate;
  late int? anotations;
  late String? checklist;
  late String? certificate;
  late String? observations;

  Inspection.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    shipName = map['shipName'];
    inspector = map['inspector'];
    inspectionType = map['inspectionType'];
    inspectionDate = map['inspectionDate'];
    anotations = map['anotations'];
    checklist = map['checklist'];
    certificate = map['certificate'];
    observations = map['observations'];
  }
}