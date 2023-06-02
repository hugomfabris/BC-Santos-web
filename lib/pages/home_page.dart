import 'package:bcsantos/controllers/inspection_controller.dart';
import 'package:flutter/material.dart';
import '../components/inspection_tile.dart';
import 'add_inspection_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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

  void _showMenu(BuildContext context) {
    setState(() {});
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
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
                      // ShellExecuteService shellExecuteService =
                      //     ShellExecuteService();
                      // shellExecuteService
                      //     .openFile(inspectionController.planPath);
                    }),
                ListTile(
                  title: const Text('Atualizar Plano de ação das Barcaças'),
                  onTap: () {
                    setState(() {
                      bcChipsVisibility = false;
                      inspectorChipsVisibility = false;
                    });
                    // _setPlanPath();
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
