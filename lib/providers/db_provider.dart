import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/ScansDB.db';
    print(path);

    // Crear base de datos

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans (id, tipo, valor)
      VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')
    ''');

    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    print(res);
    return res;
  }

  getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getTodosLosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<List<ScanModel>?> getTodosTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery(''' 
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');

    return res.isNotEmpty
        ? res.map((s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
      DELETE FROM Scans
    ''');
    return res;
  }


  Future<void> abrirCarpetaBaseDatos() async {
    try {
      // Asegurarse de que la base de datos esté inicializada
      final db = await database;
      final dbPath = db.path;
      final directory = p.dirname(dbPath);
      
      print('=== INFORMACIÓN DE LA BASE DE DATOS ===');
      print('Ruta completa: $dbPath');
      print('Directorio: $directory');
      print('Plataforma: ${Platform.operatingSystem}');
      print('=====================================');
      
      if (Platform.isWindows) {
        // Intentar múltiples formas de abrir en Windows
        try {
          await Process.run('explorer.exe', [directory]);
          print('✅ Carpeta abierta exitosamente con explorer.exe');
        } catch (e1) {
          try {
            await Process.run('start', [directory], runInShell: true);
            print('✅ Carpeta abierta exitosamente con start');
          } catch (e2) {
            print('❌ Error al abrir carpeta: $e1, $e2');
          }
        }
      } else if (Platform.isAndroid) {
        print('📱 Para Android, usa ADB:');
        print('adb shell "run-as com.example.qr_reader ls -la /data/user/0/com.example.qr_reader/app_flutter/"');
        print('📱 Para Android, ejecuta este comando en tu terminal para extraer la BD:');
        // Nota: Asegúrate de que 'com.example.qr_reader' coincida con el applicationId en tu build.gradle
        print('adb exec-out run-as com.example.qr_reader cat app_flutter/ScansDB.db > ScansDB.db');
      } else {
        print('💻 Plataforma ${Platform.operatingSystem} detectada');
      }
    } catch (e) {
      print('❌ Error general: $e');
    }
  }
}
