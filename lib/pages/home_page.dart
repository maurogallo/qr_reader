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
          // Agregar botón para abrir carpeta de BD
          IconButton(
            icon: Icon(Icons.folder_open, color: Colors.white),
            onPressed: () async {
              await DBProvider.db.abrirCarpetaBaseDatos();
              // Mostrar un snackbar con la información
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Revisa la consola para la ruta de la BD'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            tooltip: 'Abrir carpeta BD',
          ),
          // IconButton(
          //   icon: Icon(Icons.chat, color: Colors.white),
          //   onPressed: () {
          //     Navigator.pushNamed(context, 'grok_chat');
          //   },
          //   tooltip: 'Chat con Grok',
          // ),
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


