
import 'package:cloud_firestore/cloud_firestore.dart';

class CalificacionDeEmpleadoAEmpleador{
  String id;
  String idEmpleado;
  String idPublicacion;
  Timestamp fechaCreacion;
  num calificacionDeEmpleado;

  CalificacionDeEmpleadoAEmpleador({
    this.id,
    this.idEmpleado,
    this.idPublicacion,
    this.fechaCreacion,
    this.calificacionDeEmpleado
  });

  CalificacionDeEmpleadoAEmpleador.fromMap(Map snapshot, String id):
      id=id ?? '',
      idEmpleado=snapshot['idEmpleado'] ?? '',
      idPublicacion= snapshot['idPublicacion'] ?? '',
      fechaCreacion= snapshot['fechaCreacion'] ?? null,
      calificacionDeEmpleado= snapshot['calificacionDeEmpleado'] ?? 0;

  toJson(){
    return {
      "idEmpleado": idEmpleado,
      "idPublicacion": idPublicacion,
      "fechaCreacion": fechaCreacion,
      "calificacionDeEmpleado": calificacionDeEmpleado
    };
  }
}