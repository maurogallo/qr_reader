import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {
        final barcodeScanRes =
            'https://example.com'; // Aquí iría el resultado del escaneo
        
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
        scanListProvider.nuevoScan(barcodeScanRes);
        scanListProvider.nuevoScan('geo:15.33,15.66');
      },
    );
  }
}

// class QRScannerPage extends StatefulWidget {
//   const QRScannerPage({super.key});

//   @override
//   State<QRScannerPage> createState() => _QRScannerPageState();
// }

// class _QRScannerPageState extends State<QRScannerPage> {
//   bool _isScanned = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Escáner QR')),
//       body: MobileScanner(
//         onDetect: (capture) {
//           if (_isScanned) return; // Evita múltiples lecturas
//           final barcode = capture.barcodes.first;
//           final String? value = barcode.rawValue;
//           if (value != null) {
//             setState(() => _isScanned = true);
//             Navigator.pop(context); // Cierra la pantalla
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Código escaneado: $value')),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
