import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:bcsantos/models/plan.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../components/content.dart';
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

  void _showMenu(BuildContext context, bool loggedIn) {
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
              if (loggedIn) ...[
        PopupMenuItem(
          child: ListTile(
            title: const Text('Atualizar Plano de ação das Barcaças'),
            onTap: () async {
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

              setState(() {
                bcChipsVisibility = false;
                inspectorChipsVisibility = false;
              });

              try {
                final result = await fileManagement
                    .pickFiles("Plano de ação das barcaças");
                final String upload =
                    await fileManagement.uploaAndGetUrl(result, 'barcaças');
                planBC.url = upload;

                await fileManagement.updateUrl('barcaças', upload).whenComplete(
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.indigo,
                          duration: Duration(seconds: 2),
                          content: Text(
                              'Plano de ação das barcaças atualizado com sucesso'),
                        ),
                      ),
                    ); // Atualiza a URL no Firestore

                // Atualize a interface do usuário com base no resultado do upload
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.indigo,
                    duration: Duration(seconds: 2),
                    content: Text(
                        'Erro ao atualizar o plano de ação das barcaças, por favor tente novamente'),
                  ),
                );
              } finally {
                Navigator.pop(context); // Feche o diálogo de progresso
              }
            },
          ),
        ),
          PopupMenuItem(
            child: ListTile(
              title: const Text('Atualizar Plano de ação dos Rebocadores'),
              onTap: () async {
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

                setState(() {
                  bcChipsVisibility = false;
                  inspectorChipsVisibility = false;
                });

                try {
                  final result = await fileManagement
                      .pickFiles("Plano de ação dos rebocadores");
                  final String upload =
                      await fileManagement.uploaAndGetUrl(result, 'rebocadores');
                  planRB.url = upload;

                  await fileManagement
                      .updateUrl('rebocadores', upload)
                      .whenComplete(
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.indigo,
                            duration: Duration(seconds: 2),
                            content: Text(
                                'Plano de ação dos rebocadores atualizado com sucesso'),
                          ),
                        ),
                      ); // Atualiza a URL no Firestore

                  // Atualize a interface do usuário com base no resultado do upload
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.indigo,
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Erro ao atualizar o plano de ação dos rebocadores, por favor tente novamente'),
                    ),
                  );
                } finally {
                  Navigator.pop(context); // Feche o diálogo de progresso
                }
              },
            ),
          ),
        ],
        PopupMenuItem(
            child: ListTile(
              title: const Text('Plano de ação das Barcaças'),
              onTap: () async {
                try {
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('plans')
                      .where('type', isEqualTo: 'barcaças')
                      .get();
                  if (querySnapshot.size > 0) {
                    final document = querySnapshot.docs[0];
                    planBC = Plan.fromDocument(document);
                    fileManagement.openFile(planBC.url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.indigo,
                          duration: Duration(seconds: 2),
                          content: Text(
                              'Plano de ação das barcaças não encontrado, por favor atualizar')),
                    );
                  }
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.indigo,
                        duration: Duration(seconds: 2),
                        content: Text(
                            'Plano de ação das barcaças não encontrado, por favor atualizar')),
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
                  fileManagement.openFile(planRB.url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.indigo,
                        duration: Duration(seconds: 2),
                        content: Text(
                            'Plano de ação dos rebocadores não encontrado, por favor atualizar')),
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
          )]
    );
  }

  // void _showMenu(BuildContext context) {
  //   final RenderBox button = context.findRenderObject() as RenderBox;
  //   final RenderBox overlay =
  //       Overlay.of(context).context.findRenderObject() as RenderBox;
  //   final RelativeRect position = RelativeRect.fromRect(
  //     Rect.fromPoints(
  //       button.localToGlobal(Offset.zero, ancestor: overlay),
  //       button.localToGlobal(button.size.bottomRight(Offset.zero),
  //           ancestor: overlay),
  //     ),
  //     Offset.zero & overlay.size,
  //   );
  //   final appState = Provider.of<ApplicationState>(context);
  //   final menuItems = Consumer<ApplicationState>(
  //     builder: (constext, appState, _) {
  //       return [
  
  //     showMenu(
  //       context: context,
  //       position: position,
  //       items: menuItems,
  //     );
  //     }
  //   )

  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<ApplicationState>(builder: (context, appState, _) {
          return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showMenu(context, appState.loggedIn));
        }),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            if (appState.loggedIn) {
              // Usuário está logado
              GoRouter.of(context).go('/profile');
            } else {
              // Usuário não está logado
              GoRouter.of(context).go('/login');
            }
          }, icon: Consumer<ApplicationState>(
            builder: (context, appState, _) {
              return appState.loggedIn
                  ? const Icon(Icons.person)
                  : const Icon(Icons.login);
            },
          )),
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
      floatingActionButton: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          return Visibility(
            visible: appState.loggedIn,
            child: FloatingActionButton(
              onPressed: () => _addInspection(context),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
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
                  Wrap(
                    children: <Widget>[
                      Visibility(
                          visible: bcChipsVisibility,
                          child: Content(
                            child: ChipsChoice<String>.single(
                              value: selectedFilter,
                              onChanged: (val) => setState(() {
                                if (val == selectedFilter) {
                                  //removing filter
                                  inspectionController.clearFilters();
                                  selectedFilter = null;
                                } else if (selectedFilter == null) {
                                  //adding filter
                                  selectedFilter = val;
                                  inspectionController.setBCFilter(val);
                                } else {
                                  inspectionController.clearFilters();
                                  selectedFilter = val;
                                  inspectionController.setBCFilter(val);
                                }
                              }),
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: inspectionController.shipNameChips,
                                value: (i, v) => v,
                                label: (i, v) => v,
                              ),
                              choiceStyle: C2ChipStyle.filled(
                                selectedStyle: const C2ChipStyle(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Visibility(
                          visible: inspectorChipsVisibility,
                          child: Content(
                            child: ChipsChoice<String>.single(
                              value: selectedFilter,
                              onChanged: (val) => setState(() {
                                if (val == selectedFilter) {
                                  //removing filter
                                  inspectionController.clearFilters();
                                  selectedFilter = null;
                                } else if (selectedFilter == null) {
                                  //adding filter
                                  selectedFilter = val;
                                  inspectionController.setInspectorFilter(val);
                                } else {
                                  inspectionController.clearFilters();
                                  selectedFilter = val;
                                  inspectionController.setInspectorFilter(val);
                                }
                              }),
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: inspectionController.inspectorChips,
                                value: (i, v) => v,
                                label: (i, v) => v,
                              ),
                              choiceStyle: C2ChipStyle.filled(
                                selectedStyle: const C2ChipStyle(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
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
