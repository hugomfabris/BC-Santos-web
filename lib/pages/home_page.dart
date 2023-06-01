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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () => _showMenu(context),
        // ),
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
