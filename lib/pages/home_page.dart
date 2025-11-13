import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';

import 'package:qr_reader/wigets/custom_navigatorbar.dart';
import 'package:qr_reader/wigets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: Text('Historial', style: TextStyle(color: Colors.white)),
        centerTitle: true,

        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () {
              // Acción para eliminar el historial
            },
          ),
        ],
      ),

      body: _HomePageBody(),

      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    // Cambiar para mostrar la página respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    final nuevoScan = new ScanModel(valor: 'http://www.prueba.com');

    //TODO: Temporal leer la base de datos
    //DBProvider.db.nuevoScan(nuevoScan);
    // DBProvider.db.getScanById(13).then((scan) {
    //   if (kDebugMode) {
    //     print(scan?.valor);
    //   }
    // });
    DBProvider.db.getTodosLosScans().then((scans) {
      if (kDebugMode) {
        print(scans);
      }
    });

    switch (currentIndex) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
