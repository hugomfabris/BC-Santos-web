import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:bcsantos/models/inspection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';


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
  String? checklistPath;
  String? certificatePath;
  DateTime? inspectionDate;
  List<String> allowedBCRB = [
    'CD INGÁ',
    'CD ICARAÍ',
    'E-240',
    'OMS V',
    'OMS XVII',
    'SC 42',
    'SC 53',
    'SC 54',
    'ECO MARÍTIMO',
    'GEOMAR',
    'GUARATUBA II',
    'SM FLAMENGO',
    'SM PRAINHA',
    'SM VITÓRIA',
    'SM SÃO GONÇALO',
    'THOR AMIGO'
  ];
  List<String> allowedInspectors = [
    'ALAN',
    'HUGO',
    'NILO',
    'REGINALDO',
    'RAHMAN',
    'OUTRO'
  ];
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
    _inspectorController = TextEditingController();
    _inspectionTypeController = TextEditingController();
    _anotationsController = TextEditingController();
    _nameController = TextEditingController();
    _observationsController = TextEditingController();
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

  saveInspection() {
    final inspection = Inspection()
      ..inspector = _inspectorController.text.toUpperCase().trim()
      ..shipName = _nameController.text.toUpperCase().trim()
      ..inspectionType = _inspectionTypeController.text.toUpperCase().trim()
      ..anotations = int.parse(_anotationsController.text)
      ..inspectionDate = inspectionDate ?? DateTime.now()
      ..checklist = checklistPath
      ..certificate = certificatePath
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
            onPressed: () {
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
              if (!allowedBCRB
                  .contains(_nameController.text.toUpperCase().trim())) {
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
                    _nameController =
                        TextEditingController(text: 'ECO MARÍTIMO');
                    break;
                  case 'ECOMARÍTIMO':
                    _nameController =
                        TextEditingController(text: 'ECO MARÍTIMO');
                    break;
                  case 'ECO MARITIMO':
                    _nameController =
                        TextEditingController(text: 'ECO MARÍTIMO');
                    break;
                  case 'ECO-MARITIMO':
                    _nameController =
                        TextEditingController(text: 'ECO MARÍTIMO');
                    break;
                  case 'ECO-MARÍTIMO':
                    _nameController =
                        TextEditingController(text: 'ECO MARÍTIMO');
                    break;
                  case 'GUARATUBA 2':
                    _nameController =
                        TextEditingController(text: 'GUARATUBA II');
                    break;
                  case 'GUARATUBAII':
                    _nameController =
                        TextEditingController(text: 'GUARATUBA II');
                    break;
                  case 'GUARATUBA':
                    _nameController =
                        TextEditingController(text: 'GUARATUBA II');
                    break;
                  case 'FLAMENGO':
                    _nameController =
                        TextEditingController(text: 'SM FLAMENGO');
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
                    _nameController =
                        TextEditingController(text: 'SM SÃO GONÇALO');
                    break;
                  case 'SAO GONCALO':
                    _nameController =
                        TextEditingController(text: 'SM SÃO GONÇALO');
                    break;
                  case 'SM SAO GONCALO':
                    _nameController =
                        TextEditingController(text: 'SM SÃO GONÇALO');
                    break;

                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.indigo,
                          duration: Duration(seconds: 2),
                          content: Text("Embarcação não registrada")),
                    );
                }
              }
              if (!allowedInspectors
                  .contains(_inspectorController.text.toUpperCase().trim())) {
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
              } else {
                saveInspection();
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
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          dialogTitle: "Selecione o certificado da embarcação",
                          allowedExtensions: ['pdf'],
                        );

                        if (result != null) {
                          final path = result.paths.first;
                          setState(() {
                            certificatePath = path;
                          });
                        } else {
                          certificatePath = null;
                        }
                      },
                      child: Text(certificatePath == null
                          ? "Selecionar Certificado"
                          : certificatePath!)),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          dialogTitle: "Selecione o checklist da inspeção",
                          allowedExtensions: ['pdf', 'xls', 'xlsx'],
                        );

                        if (result != null) {
                          final path = result.paths.first;
                          setState(() {
                            checklistPath = path;
                          });
                        } else {
                          checklistPath = null;
                        }
                      },
                      child: Text(checklistPath == null
                          ? "Selecionar Checklist"
                          : checklistPath!)),
                  const SizedBox(
                    height: 15,
                  ),
                ])));
            }
}
