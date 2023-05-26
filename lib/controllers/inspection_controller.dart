import 'package:bcsantos/models/hive_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InspectionController extends ChangeNotifier {
  InspectionController() {
    init();
  }

  final inspectionBox = Hive.box<Inspection>('inspectionBox');
  final planBox = Hive.box<Plan>('planBox');
  late List<Inspection> _inspections = [];
  late List<String> _bcChips = [];
  late List<String> _inspectorChips = [];
  late String _planPath = '';

  void init() {
    if (inspectionBox.isEmpty) {
      bcChips = ['SEM INSPEÇÕES'];
      inspectorChips = ['SEM INSPEÇÕES'];
    } else {
      bcChips = [];
      inspectorChips = [];
      for (var element in inspectionBox.values) {
        _inspections.add(element);
        if (_bcChips.contains(element.name) == false) {
          _bcChips.add(element.name.toString());
        }
        if (_inspectorChips.contains(element.inspector) == false) {
          _inspectorChips.add(element.inspector.toString());
        }
      }
      _inspections.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));
    }
    if (planBox.isEmpty) {
    } else {
      planPath = planBox.getAt(0)!.planPath.toString();
    }
  }

  List<Inspection> get inspections {
    return _inspections;
  }

  set inspections(List<Inspection> inspections) {
    _inspections = inspections;
    notifyListeners();
  }

  String get planPath {
    return _planPath;
  }

  set planPath(String plan) {
    _planPath = plan;
    notifyListeners();
  }

  List<String> get bcChips {
    return _bcChips;
  }

  set bcChips(List<String> chipsNames) {
    _bcChips = chipsNames;
    notifyListeners();
  }

  List<String> get inspectorChips {
    return _inspectorChips;
  }

  set inspectorChips(List<String> chipsNames) {
    _inspectorChips = chipsNames;
    notifyListeners();
  }

  void addInspection(Inspection inspection) {
    if (inspectionBox.isEmpty) {
      bcChips = [];
      inspectorChips = [];
    }
    _inspections.add(inspection);
    notifyListeners();
    inspectionBox.add(inspection);
    if (_bcChips.contains(inspection.name) == false) {
      _bcChips.add(inspection.name.toString());
    }
    if (_inspectorChips.contains(inspection.inspector) == false) {
      _inspectorChips.add(inspection.inspector.toString());
    }
    inspections.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));
  }

  void removeInspection(Inspection inspection) {
    inspection.delete();
    _inspections.remove(inspection);
    notifyListeners();
    if (inspectionBox.isEmpty) {
      bcChips = ['SEM INSPEÇÕES'];
      inspectorChips = ['SEM INSPEÇÕES'];
    } else {
      if (_bcChips.contains(inspection.name) == true) {
        return;
      } else {
        _bcChips.remove(inspection.name.toString());
      }
      if (_inspectorChips.contains(inspection.inspector) == true) {
        return;
      } else {
        _inspectorChips.remove(inspection.inspector.toString());
      }
    }
  }

  void setPlanPath(String path) {
    if (planBox.isEmpty) {
      planBox.add(Plan()
        ..id = 0.toString()
        ..planPath = path);
    } else {
      planBox.clear();
      planBox.putAt(
          0,
          Plan()
            ..id = 0.toString()
            ..planPath = path);
    }
    planPath = path;
    notifyListeners();
  }

  setBCFilter(String name) {
    _inspections =
        _inspections.where((element) => element.name == name).toList();
    notifyListeners();
  }

  setInspectorFilter(String inspector) {
    _inspections = _inspections
        .where((element) => element.inspector == inspector)
        .toList();
    notifyListeners();
  }

  clearFilters() {
    _inspections = [];
    init();
    notifyListeners();
  }
}
