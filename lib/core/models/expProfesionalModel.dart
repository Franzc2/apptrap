import 'package:cloud_firestore/cloud_firestore.dart';

class ExpProfesional{
  String id;
  Timestamp fechaCreacion;
  String empresa;
  String cargo;
  String region;
  Timestamp fechaInicio;
  Timestamp fechaFin;
  bool actualmente;
  String funciones;

  ExpProfesional({
    this.id,
    this.fechaCreacion,
    this.empresa,
    this.cargo,
    this.region,
    this.fechaInicio,
    this.fechaFin,
    this.actualmente,
    this.funciones,
  });

  ExpProfesional.fromMap(Map snapshot, String id):
        id=id ?? '',
        fechaCreacion=snapshot['fechaCreacion'] ?? null,
        empresa=snapshot['empresa'] ?? '',
        cargo=snapshot['cargo'] ?? '',
        region=snapshot['region'] ?? '',
        fechaInicio=snapshot['fechaInicio'] ?? null,
        fechaFin=snapshot['fechaFin'] ?? null,
        actualmente=snapshot['actualmente'] ?? null,
        funciones=snapshot['funciones'] ?? '';

  toJson(){
    return{
      "fechaCreacion": fechaCreacion,
      "empresa": empresa,
      "cargo": cargo,
      "region": region,
      "fechaInicio":fechaInicio,
      "fechaFin": fechaFin,
      "actualmente":actualmente,
      "funciones":funciones
    };
  }

}