import 'dart:async';
import 'package:bcsantos/models/inspection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InspectionController extends ChangeNotifier {
  InspectionController() {
    init();
  }

  @override
  void dispose() {
    _inspectionsSubscription?.cancel();
    super.dispose();
  }

  StreamSubscription<QuerySnapshot>? _inspectionsSubscription;
  final List<Inspection> _inspections = [];
  CollectionReference? inspectionsRef;

  void init() {
    
    _inspectionsSubscription = FirebaseFirestore.instance
        .collection('inspections')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> data) {
          _inspections.clear();
      for (final document in data.docs) {
        final inspection = Inspection.fromDocument(document);
        inspections.add(inspection);
      }
      _inspections.sort((a, b) => b.inspectionDate!.compareTo(a.inspectionDate!));
      notifyListeners();
    });
  }

  List<Inspection> get inspections => _inspections;

  // set inspections(List<Inspection> inspections) {
  //   _inspections = inspections;
  //   notifyListeners();
  // }

  addInspection(Inspection inspection) {
    inspections.add(inspection);
    notifyListeners();
    FirebaseFirestore.instance
        .collection('inspections')
        .add(<String, dynamic>{
      'shipName': inspection.shipName,
      'inspector': inspection.inspector,
      'inspectionType': inspection.inspectionType,
      'inspectionDate': inspection.inspectionDate,
      'anotations': inspection.anotations,
      'checklist': inspection.checklist,
      'certificate': inspection.certificate,
      'observations': inspection.observations,
    });
  }

  deleteInspection(Inspection inspection) {
    inspections.remove(inspection);
    notifyListeners();
    FirebaseFirestore.instance
        .collection('inspections')
        .doc(inspection.id)
        .delete();
  }
}
