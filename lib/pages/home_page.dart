import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/inspection_tile.dart';
import 'package:bcsantos/components/content.dart';
import 'add_inspection_page.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bcsantos/services/shell_execute_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InspectionController inspectionController;
  bool bcChipsVisibility = false;
  bool inspectorChipsVisibility = false;
  String? selectedFilter;

  @override
  void initState() {
    inspectionController = InspectionController();
    super.initState();
  }

  void _addInspection(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddInspectionPage(
              inspectionController: inspectionController,
            ),
        fullscreenDialog: true));
  }

  void _setPlanPath() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xls', 'xlsx'],
        dialogTitle: "Atualize o plano de inspeção");
    if (result != null) {
      setState(() {
        inspectionController.setPlanPath(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  void _showMenu(BuildContext context) {
    setState(() {});
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Column(
              children: [
                ListTile(
                    title: const Text('Plano de ação das Barcaças'),
                    onTap: () {
                      setState(() {
                        bcChipsVisibility = false;
                        inspectorChipsVisibility = false;
                      });
                      ShellExecuteService shellExecuteService =
                          ShellExecuteService();
                      shellExecuteService
                          .openFile(inspectionController.planPath);
                    }),
                ListTile(
                  title: const Text('Atualizar Plano de ação das Barcaças'),
                  onTap: () {
                    setState(() {
                      bcChipsVisibility = false;
                      inspectorChipsVisibility = false;
                    });
                    _setPlanPath();
                  },
                ),
                ListTile(
                  title: const Text('Filtro por Embarcações'),
                  onTap: () {
                    setState(() {
                      bcChipsVisibility = !bcChipsVisibility;
                      inspectorChipsVisibility = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Filtro por Inspetores'),
                  onTap: () {
                    setState(() {
                      inspectorChipsVisibility = !inspectorChipsVisibility;
                      bcChipsVisibility = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _showMenu(context),
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 850) {
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
                                source: inspectionController.bcChips,
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
