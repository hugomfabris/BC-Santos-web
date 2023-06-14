import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:bcsantos/models/plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/inspection_tile.dart';
import 'add_inspection_page.dart';
import '../services/file_management.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InspectionController inspectionController;
  late Plan planBC;
  late Plan planRB;
  late FileManagement fileManagement;
  bool bcChipsVisibility = false;
  bool inspectorChipsVisibility = false;
  bool isLogged = false;
  String? selectedFilter;

  @override
  void initState() {
    inspectionController = InspectionController();
    fileManagement = FileManagement();
    planBC = Plan();
    planRB = Plan();
    super.initState();
  }

  void _addInspection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddInspectionPage(
              inspectionController: inspectionController,
            ),
        fullscreenDialog: true));
  }

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: ListTile(
            title: const Text('Plano de ação das Barcaças'),
            onTap: () async {
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('plans')
                  .where('type', isEqualTo: 'barcaças')
                  .get();
              if (querySnapshot.size > 0) {
                final document = querySnapshot.docs[0];
                final url = document['url'];
                planBC = Plan.fromDocument(document);
                print(planBC);
                fileManagement.openFile(planBC.url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Plano de ação das barcaças não encontrado, por favor atualize o plano de ação')),
                );
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Plano de ação das Rebocadores'),
            onTap: () async {
              final querySnapshot = await FirebaseFirestore.instance
                  .collection('plans')
                  .where('type', isEqualTo: 'rebocadores')
                  .get();
              if (querySnapshot.size > 0) {
                final document = querySnapshot.docs[0];
                planRB = Plan.fromDocument(document);
                print(planRB);
                fileManagement.openFile(planRB.url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Plano de ação dos rebocadores não encontrado, por favor atualize o plano de ação')),
                );
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Atualizar Plano de ação das Barcaças'),
            onTap: () async {
              setState(() {
                bcChipsVisibility = false;
                inspectorChipsVisibility = false;
              });
              try {
                final result = await fileManagement
                    .pickFiles("Plano de ação das barcaças");
                final String? upload =
                    await fileManagement.uploadPlan(result, 'barcaças');
                
                planBC.url = upload;
                await planBC.updateUrl('barcaças'); // Atualiza a URL no Firestore
                print(planBC);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Plano de ação das barcaças atualizado com sucesso')),
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Erro ao atualizar o plano de ação das barcaças, por favor tente novamente')),
                );
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Atualizar Plano de ação dos Rebocadores'),
            onTap: () async {
              setState(() {
                bcChipsVisibility = false;
                inspectorChipsVisibility = false;
              });
              try {
                final result = await fileManagement
                    .pickFiles("Plano de ação dos rebocadores");
                final String? upload =
                    await fileManagement.uploadPlan(result, 'rebocadores');
                
                planRB.url = upload;
                await planRB.updateUrl('rebocadores'); // Atualiza a URL no Firestore
                print(planRB);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Plano de ação dos rebocadores atualizado com sucesso')),
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Erro ao atualizar o plano de ação dos rebocadores, por favor tente novamente')),
                );
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Filtro por Embarcações'),
            onTap: () {
              setState(() {
                bcChipsVisibility = !bcChipsVisibility;
                inspectorChipsVisibility = false;
              });
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Filtro por Inspetores'),
            onTap: () {
              setState(() {
                inspectorChipsVisibility = !inspectorChipsVisibility;
                bcChipsVisibility = false;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _showMenu(context),
        ),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 900) {
            return _buildLayout('mobile');
          } else if (constraints.maxWidth <= 1200) {
            return _buildLayout('tablet');
          } else {
            return _buildLayout('desktop');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addInspection(context),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildLayout(String platform) {
    return Center(
        child: AnimatedBuilder(
            animation: inspectionController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: inspectionController.inspections.length,
                    itemBuilder: (context, index) {
                      final inspection =
                          inspectionController.inspections[index];
                      return InspectionTile(
                          inspection: inspection,
                          inspectionController: inspectionController,
                          platform: platform);
                    },
                  ))
                ],
              );
            }));
  }
}
