import 'package:cloud_firestore/cloud_firestore.dart';

class Postulante{
  String id;
  String idUserPostulante;
  num contraOfertaPresupuesto;
  String mensajeOpcional;
  String estadoPostulacion;

  Postulante({
    this.id,
    this.idUserPostulante,
    this.contraOfertaPresupuesto,
    this.mensajeOpcional,
    this.estadoPostulacion
});

  Postulante.fromMap(Map snapshot, String id):
      id=id ?? '',
  idUserPostulante=snapshot['idUserPostulante'] ?? '',
  contraOfertaPresupuesto=snapshot['contraOfertaPresupuesto'] ?? 0,
  mensajeOpcional=snapshot['mensajeOpcional'] ?? '',
  estadoPostulacion=snapshot['estadoPostulacion'] ?? '';

  toJson(){
    return{
      "idUserPostulante": idUserPostulante,
      "contraOfertaPresupuesto": contraOfertaPresupuesto,
      "mensajeOpcional": mensajeOpcional,
      "estadoPostulacion": estadoPostulacion
    };
  }

}