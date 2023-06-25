import 'dart:async';
import 'package:bcsantos/models/inspection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late List<Inspection> _inspections = [];
  final List<String> inspectorChips = ['SEM INSPEÇÕES'];
  final List<String> shipNameChips = ['SEM INSPEÇÕES'];
  final List<String> inspectionTypeChips = ['SEM INSPEÇÕES'];
  CollectionReference? inspectionsRef;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

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
      chipsFilling();
      _inspections
          .sort((a, b) => b.inspectionDate!.compareTo(a.inspectionDate!));
      notifyListeners();
    });
  }

  List<Inspection> get inspections => _inspections;

  set inspections(List<Inspection> inspections) {
    _inspections = inspections;
    notifyListeners();
  }

  void chipsFilling() {
    if (_inspections.isEmpty) {
      // return nothing
    } else {
      inspectorChips.clear();
      shipNameChips.clear();
      inspectionTypeChips.clear();
      for (final inspection in _inspections) {
        if (!inspectorChips.contains(inspection.inspector!)) {
          inspectorChips.add(inspection.inspector!);
        }
        if (!shipNameChips.contains(inspection.shipName!)) {
          shipNameChips.add(inspection.shipName!);
        }
        if (!inspectionTypeChips.contains(inspection.inspectionType!)) {
          inspectionTypeChips.add(inspection.inspectionType!);
        }
      }
    }
  }

  addInspection(Inspection inspection) {
    inspections.add(inspection);
    notifyListeners();
    FirebaseFirestore.instance.collection('inspections').add(<String, dynamic>{
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

  deleteInspection(Inspection inspection) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      if (inspection.certificate != null) {
        final fileToDelete = storageRef.child(
            'certificados/${inspection.shipName!.toLowerCase()}/${dateFormat.format(inspection.inspectionDate!).toString()} - certificado ${inspection.shipName!.toLowerCase()}.pdf}');
        try {
          await fileToDelete.delete();
          print('Certificado deletado');
        } catch (e) {
          print(e);
        }
      } else {
        // No certificate to delete
      }
      if (inspection.checklist != null) {
        final fileToDelete = storageRef.child(
            'checklists/${inspection.shipName!.toLowerCase()}/${dateFormat.format(inspection.inspectionDate!).toString()} - checklist ${inspection.shipName!.toLowerCase()}.pdf}');
        try {
          await fileToDelete.delete();
        } catch (e) {
          print(e);
        }
      } else {
        // No checklist to delete
      }
      // Delete the document inside the Firebase Firestore
      await FirebaseFirestore.instance
          .collection('inspections')
          .doc(inspection.id)
          .delete();

      // Remove the inspection from the local list and notify listeners
      inspections.remove(inspection);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    if (inspections.isEmpty) {
      inspectorChips.clear();
      shipNameChips.clear();
      inspectionTypeChips.clear();
      inspectorChips.add('SEM INSPEÇÕES');
      shipNameChips.add('SEM INSPEÇÕES');
      inspectionTypeChips.add('SEM INSPEÇÕES');

    } else {
      chipsFilling();
    }
  }

  clearFilters() {
    _inspections = [];
    init();
    notifyListeners();
  }

  setShipFilter(String name) {
    _inspections =
        _inspections.where((element) => element.shipName == name)
        .toList();
    notifyListeners();
  }

  setInspectorFilter(String inspector) {
    _inspections = _inspections
        .where((element) => element.inspector == inspector)
        .toList();
    notifyListeners();
  }

  setInspectionTypeFilter(String type) {
    _inspections = _inspections
        .where((element) => element.inspectionType == type)
        .toList();
    notifyListeners();
  }
}
