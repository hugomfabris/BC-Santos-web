import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:bcsantos/models/inspection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../services/file_management.dart';

class AddInspectionPage extends StatefulWidget {
  final InspectionController inspectionController;

  const AddInspectionPage({super.key, required this.inspectionController});

  @override
  State<AddInspectionPage> createState() => _AddInspectionPageState();
}

class _AddInspectionPageState extends State<AddInspectionPage> {
  late TextEditingController _inspectorController;
  late TextEditingController _inspectionTypeController;
  late TextEditingController _anotationsController;
  late TextEditingController _nameController;
  late TextEditingController _observationsController;
  String? checklistUrl;
  String? certificateUrl;
  DateTime? inspectionDate;
  DateFormat dateFormat = DateFormat("dd.MM.yyyy");
  late FileManagement fileManagement;
  List<String> allowedBCRB = [];
  List<String> allowedInspectors = [];
  List<String> allowedInspectionTypes = [
    'ACIDENTE',
    'ACOMPANHAMENTO',
    'ALEATÓRIA',
    'INCIDENTE',
    'SEMESTRAL'
  ];

  @override
  void initState() {
    super.initState();
    fileManagement = FileManagement();
    _inspectorController = TextEditingController();
    _inspectionTypeController = TextEditingController();
    _anotationsController = TextEditingController();
    _nameController = TextEditingController();
    _observationsController = TextEditingController();
    _initializeAsyncData();
  }

  @override
  void dispose() {
    _inspectorController.dispose();
    _inspectionTypeController.dispose();
    _anotationsController.dispose();
    _nameController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<List<String>> allowedInspectorsList() async {
    FirebaseFirestore.instance
        .collection('inspectors')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> data) {
      for (final inspector in data.docs) {
        allowedInspectors.add(inspector['name']);
      }
    });

    return allowedInspectors;
  }

  Future<List<String>> allowedBCRBList() async {
    FirebaseFirestore.instance
        .collection('ships')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> data) {
      for (final ship in data.docs) {
        allowedBCRB.add(ship['shipName']);
      }
    });

    return allowedBCRB;
  }

  void _initializeAsyncData() async {
    // Operações assíncronas
    await allowedInspectorsList();
    await allowedBCRBList();
    setState(() {});
  }

  Future<bool> checkBCRB() async {
    if (!allowedBCRB.contains(_nameController.text.toUpperCase().trim())) {
      switch (_nameController.text.toUpperCase().trim()) {
        case 'CD INGA':
          _nameController = TextEditingController(text: 'CD INGÁ');
          break;
        case 'INGÁ':
          _nameController = TextEditingController(text: 'CD INGÁ');
          break;
        case 'INGA':
          _nameController = TextEditingController(text: 'CD INGÁ');
          break;
        case 'CD ICARAI':
          _nameController = TextEditingController(text: 'CD ICARAÍ');
          break;
        case 'ICARAI':
          _nameController = TextEditingController(text: 'CD ICARAÍ');
          break;
        case 'ICARAÍ':
          _nameController = TextEditingController(text: 'CD ICARAÍ');
          break;
        case 'E240':
          _nameController = TextEditingController(text: 'E-240');
          break;
        case 'E 240':
          _nameController = TextEditingController(text: 'E-240');
          break;
        case 'SC42':
          _nameController = TextEditingController(text: 'SC 42');
          break;
        case 'SC-42':
          _nameController = TextEditingController(text: 'SC 42');
          break;
        case 'SC54':
          _nameController = TextEditingController(text: 'SC 54');
          break;
        case 'SC-54':
          _nameController = TextEditingController(text: 'SC 54');
          break;
        case 'ECOMARITIMO':
          _nameController = TextEditingController(text: 'ECO MARÍTIMO');
          break;
        case 'ECOMARÍTIMO':
          _nameController = TextEditingController(text: 'ECO MARÍTIMO');
          break;
        case 'ECO MARITIMO':
          _nameController = TextEditingController(text: 'ECO MARÍTIMO');
          break;
        case 'ECO-MARITIMO':
          _nameController = TextEditingController(text: 'ECO MARÍTIMO');
          break;
        case 'ECO-MARÍTIMO':
          _nameController = TextEditingController(text: 'ECO MARÍTIMO');
          break;
        case 'GUARATUBA 2':
          _nameController = TextEditingController(text: 'GUARATUBA II');
          break;
        case 'GUARATUBAII':
          _nameController = TextEditingController(text: 'GUARATUBA II');
          break;
        case 'GUARATUBA':
          _nameController = TextEditingController(text: 'GUARATUBA II');
          break;
        case 'FLAMENGO':
          _nameController = TextEditingController(text: 'SM FLAMENGO');
          break;
        case 'PRAINHA':
          _nameController = TextEditingController(text: 'SM PRAINHA');
          break;
        case 'VITÓRIA':
          _nameController = TextEditingController(text: 'SM VITÓRIA');
          break;
        case 'VITORIA':
          _nameController = TextEditingController(text: 'SM VITÓRIA');
          break;
        case 'SM VITORIA':
          _nameController = TextEditingController(text: 'SM VITÓRIA');
          break;
        case 'SÃO GONÇALO':
          _nameController = TextEditingController(text: 'SM SÃO GONÇALO');
          break;
        case 'SAO GONCALO':
          _nameController = TextEditingController(text: 'SM SÃO GONÇALO');
          break;
        case 'SM SAO GONCALO':
          _nameController = TextEditingController(text: 'SM SÃO GONÇALO');
          break;

        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.indigo,
                duration: Duration(seconds: 2),
                content: Text("Embarcação não registrada")),
          );
      }
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkInspectors() async {
    if (!allowedInspectors.contains(_inspectorController.text.toUpperCase().trim())) {
      switch (_inspectorController.text.toUpperCase().trim()) {
        case 'ALAN PATRÍCIO':
          _inspectorController = TextEditingController(text: 'ALAN');
          break;
        case 'ALAN PATRICIO':
          _inspectorController = TextEditingController(text: 'ALAN');
          break;
        case 'HUGO FABRIS':
          _inspectorController = TextEditingController(text: 'HUGO');
          break;
        case 'NILO ORLANDI':
          _inspectorController = TextEditingController(text: 'NILO');
          break;
        case 'REGINALDO LEITÃO':
          _inspectorController =
              TextEditingController(text: 'REGINALDO');
          break;
        case 'REGINALDO LEITAO':
          _inspectorController =
              TextEditingController(text: 'REGINALDO');
          break;
        case 'RAHMAN BEDUIN':
          _inspectorController =
              TextEditingController(text: 'RAHMAN');
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.indigo,
                duration: Duration(seconds: 2),
                content: Text("Inspetor não cadastrado")),
          );
      }
      return false;
    } 
    else {
      return true;
    }
  }

  saveInspection() {
    final inspection = Inspection()
      ..inspector = _inspectorController.text.toUpperCase().trim()
      ..shipName = _nameController.text.toUpperCase().trim()
      ..inspectionType = _inspectionTypeController.text.toUpperCase().trim()
      ..anotations = int.parse(_anotationsController.text)
      ..inspectionDate = inspectionDate ?? DateTime.now()
      ..checklist = checklistUrl
      ..certificate = certificateUrl
      ..observations = _observationsController.text.trim();
    widget.inspectionController.addInspection(inspection);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Inspeção"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _inspectorController.text.isEmpty ||
                  _inspectionTypeController.text.isEmpty ||
                  _anotationsController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text("Preencha todos os campos")),
                );
                return;
              }
              if (await checkBCRB()) {
                if (await checkInspectors()) {
                  saveInspection();
              }
              
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text("Confira os campos")),
                );
              }
            },
            child: const Icon(Icons.save)),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 600) {
              return _buildLayout(20.0);
            } else if (constraints.maxWidth <= 1200) {
              return _buildLayout(100.0);
            } else {
              return _buildLayout(200.0);
            }
          },
        ));
  }

  Widget _buildLayout(double paddingNumber) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingNumber),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Barcaça/Rebocador",
                        suffixIcon: Icon(Icons.directions_boat)),
                  ),
                  TextFormField(
                    controller: _inspectorController,
                    decoration: const InputDecoration(
                        labelText: "Inspetor", suffixIcon: Icon(Icons.person)),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _anotationsController,
                    decoration: const InputDecoration(
                      labelText: "Anotações",
                      suffixIcon: Icon(Icons.note),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownSearch<String?>(
                      items: allowedInspectionTypes,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Tipo de inspeção",
                        ),
                      ),
                      onChanged: (String? value) =>
                          _inspectionTypeController.text = value!),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                      controller: _observationsController,
                      maxLines: 10,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Observações')),
                  const SizedBox(
                    height: 15,
                  ),

                  ///button to pick date
                  ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                            context: context,
                            helpText: "Selecione a data",
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101));
                        setState(() {
                          inspectionDate = date;
                        });
                      },
                      child: Text(inspectionDate == null
                          ? "Selecionar Data"
                          : inspectionDate.toString())),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var bcrb = await checkBCRB();
                        if (bcrb) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertDialog(
                              title: Text('Upload em progresso'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  LinearProgressIndicator(), // Barra de progresso
                                  SizedBox(height: 16),
                                  Text(
                                      'Aguarde enquanto o arquivo está sendo carregado...'),
                                ],
                              ),
                            ),
                          );

                          final result =
                              await fileManagement.pickFiles("certificado");

                          try {
                            if (result != null) {
                              final effectiveInspectionDate =
                                  inspectionDate ?? DateTime.now();
                              final upload = await fileManagement
                                  .uploaAndGetUrl(
                                      result,
                                      "certificados",
                                      effectiveInspectionDate,
                                      _nameController.text)
                                  .whenComplete(() =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.indigo,
                                          duration: Duration(seconds: 2),
                                          content: Text("Upload concluído"),
                                        ),
                                      ));
                              setState(() {
                                certificateUrl = upload;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.indigo,
                                  duration: Duration(seconds: 2),
                                  content: Text("Upload cancelado"),
                                ),
                              );
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            Navigator.pop(
                                context); // Feche o diálogo de progresso
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.indigo,
                              duration: Duration(seconds: 2),
                              content: Text(
                                  "Insira corretamente o nome da barcaça ou rebocador"),
                            ),
                          );
                        }
                      },
                      child: Text(certificateUrl == null
                          ? "Selecionar Certificado"
                          : certificateUrl!.toString())),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const AlertDialog(
                            title: Text('Upload em progresso'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                LinearProgressIndicator(), // Barra de progresso
                                SizedBox(height: 16),
                                Text(
                                    'Aguarde enquanto o arquivo está sendo carregado...'),
                              ],
                            ),
                          ),
                        );

                        final result =
                            await fileManagement.pickFiles("checklist");

                        try {
                          if (result != null) {
                            final effectiveInspectionDate =
                                inspectionDate ?? DateTime.now();
                            final upload = await fileManagement
                                .uploaAndGetUrl(
                                    result,
                                    "checklists",
                                    effectiveInspectionDate,
                                    _nameController.text)
                                .whenComplete(() =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.indigo,
                                        duration: Duration(seconds: 2),
                                        content: Text("Upload concluído"),
                                      ),
                                    ));
                            setState(() {
                              checklistUrl = upload;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.indigo,
                                duration: Duration(seconds: 2),
                                content: Text("Upload cancelado"),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          Navigator.pop(
                              context); // Feche o diálogo de progresso
                        }
                      },
                      child: Text(checklistUrl == null
                          ? "Selecionar Checklist"
                          : checklistUrl!.toString())),
                  const SizedBox(
                    height: 15,
                  ),
                ])));
  }
}
