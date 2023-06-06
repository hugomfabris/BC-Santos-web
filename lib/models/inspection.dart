import 'dart:typed_data';

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

  Inspection.fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    id = document.id;
    shipName = document.data()['shipName'] as String;
    inspector = document.data()['inspector'] as String;
    inspectionType = document.data()['inspectionType'] as String;
    anotations = document.data()['anotations'] as int;
    checklist = document.data()['checklist'] as String?;
    certificate = document.data()['certificate'] as String?;
    observations = document.data()['observations'] as String;
    final inspectionTimeStamp = document.data()['inspectionDate'] as Timestamp;
    inspectionDate = inspectionTimeStamp.toDate();
  }

  Map<String, dynamic> toFirestoreMap() {

    Timestamp inspectionTimeStamp = Timestamp.fromDate(inspectionDate!);

    return {
      'shipName': shipName,
      'inspector': inspector,
      'inspectionType': inspectionType,
      'anotations': anotations,
      'checklist': checklist,
      'certificate': certificate,
      'observations': observations,
      'inspectionDate': inspectionTimeStamp,
    };
  }


  @override
  String toString() {
    return 'Inspection{id: $id, shipName: $shipName, inspector: $inspector, inspectionType: $inspectionType, inspectionDate: $inspectionDate, anotations: $anotations, checklist: $checklist, certificate: $certificate, observations: $observations}';
  }
}
