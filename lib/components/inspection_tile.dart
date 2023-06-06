import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bcsantos/controllers/inspection_controller.dart';
// import 'package:bcsantos/services/shell_execute_service.dart';
import 'package:intl/intl.dart';
import 'package:bcsantos/pages/add_inspection_page.dart';
import 'package:bcsantos/models/inspection.dart';

class InspectionTile extends StatefulWidget {
  final Inspection inspection;
  final InspectionController inspectionController;
  final String platform;

  const InspectionTile(
      {super.key,
      required this.inspection,
      required this.inspectionController,
      required this.platform});

  @override
  State<InspectionTile> createState() => InspectionTileState();
}

class InspectionTileState extends State<InspectionTile> {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  void deleteInspection() {
    widget.inspectionController.deleteInspection(widget.inspection);
  }

  void editInspection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddInspectionPage(
              inspectionController: widget.inspectionController,
            ),
        fullscreenDialog: true));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String platform = widget.platform;
    if (platform == 'mobile') {
      return buildTile(Text(widget.inspection.shipName!), 
      Center(
        child: Column(
      children: [
        Text(dateFormat.format(widget.inspection.inspectionDate!)),
        Text(widget.inspection.inspector!),
      ],
    )));
    } else {
      return buildTile(
          DataTable(columns: const [
              DataColumn(label: Text('BC/RB', textAlign: TextAlign.center)),
              DataColumn(label: Text('INSPETOR', textAlign: TextAlign.center)),
              DataColumn(label: Text('ANOTAÇÕES', textAlign: TextAlign.center)),
              DataColumn(label: Text('INSPEÇÃO', textAlign: TextAlign.center)),
              DataColumn(label: Text('DATA', textAlign: TextAlign.center))
            ], rows: [
              DataRow(cells: [
                DataCell(Text(widget.inspection.shipName!,
                    textAlign: TextAlign.center)),
                DataCell(Text(widget.inspection.inspector!,
                    textAlign: TextAlign.center)),
                DataCell(Text(widget.inspection.anotations.toString(),
                    textAlign: TextAlign.center)),
                DataCell(Text(widget.inspection.inspectionType!,
                    textAlign: TextAlign.center)),
                DataCell(Text(
                  dateFormat.format(widget.inspection.inspectionDate!),
                )),
              ])
            ]),
            null);
    }
  }

  void openFile(url) async {
    final fileReference = FirebaseStorage.instance.refFromURL(url);
    final downloadURL = await fileReference.getDownloadURL();
    print(downloadURL);

    final anchorElement = AnchorElement(href: downloadURL)
      ..setAttribute('target', '_blank')
      ..setAttribute('rel', 'noopener noreferrer');
    anchorElement.click();
  }

  buildTile(Widget data, Widget? subtitle) {
    return Card(
        child: ListTile(
            title: Center(
              child: data,
            ),
            leading: CircleAvatar(child: Text(widget.inspection.inspector![0])),

            subtitle: subtitle,
            trailing: Wrap(children: [
              IconButton(
                  icon: const Icon(Icons.workspace_premium_sharp),
                  onPressed: () {
                    if (widget.inspection.certificate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.indigo,
                            duration: Duration(seconds: 2),
                            content: Text('Inspeção não possui certificado')),
                      );
                    } else {
                      openFile(widget.inspection.certificate);
                    }
                  }),
              IconButton(
                  icon: const Icon(Icons.assignment),
                  onPressed: () {
                    if (widget.inspection.checklist == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.indigo,
                            duration: Duration(seconds: 2),
                            content: Text('Inspeção não possui checklist')),
                      );
                    } else {
                      openFile(widget.inspection.checklist);
                    }
                  }),
            ]),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return GestureDetector (
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child:
                        ListView(children: [
                          AlertDialog(
                            title: Center(
                                child: SelectableText(widget.inspection.shipName!)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SelectableText(
                                    'Data: ${dateFormat.format(widget.inspection.inspectionDate!)}'),
                                const SizedBox(height: 10),
                                SelectableText(
                                    'Inspetor: ${widget.inspection.inspector!}'),
                                const SizedBox(height: 10),
                                SelectableText(
                                    'Inspeção: ${widget.inspection.inspectionType!}'),
                                const SizedBox(height: 30),
                                SelectableText(widget.inspection.observations!)
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteInspection();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Deletar')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Fechar'))
                            ],
                            actionsAlignment: MainAxisAlignment.center,
                          )
                        ]));
                      });
                }));
              }
}
