import 'package:flutter/material.dart';
import 'package:qr_reader/wigets/scan_tiles.dart';

class DireccionesPage extends StatelessWidget {
   
 
  @override
  Widget build(BuildContext context) {   
   return const ScanTiles(tipo: 'http');
  }
}