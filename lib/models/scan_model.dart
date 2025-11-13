import 'dart:convert';


ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({
         this.id = 0,
         this.tipo = '',
        required this.valor,
    }){
      if (valor.contains('http')) {
        tipo = 'http';
      } else {
        tipo = 'geo';
      }
    }

    int id;
    String tipo;
    String valor;

    
    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() {
  final map = {
    "tipo": tipo,
    "valor": valor,
  };
  if (id != 0) {
    map["id"] = id as String;
  }
  return map;
}

}
