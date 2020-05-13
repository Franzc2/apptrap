import 'package:cloud_firestore/cloud_firestore.dart';

class PropuestaPostulante{
  String id;
  String idUserPostulante;
  num contraOfertaPresupuesto;
  String mensajeOpcional;
  String estadoPostulacion;
  Timestamp fechaCreacion;

  PropuestaPostulante({
    this.id,
    this.idUserPostulante,
    this.contraOfertaPresupuesto,
    this.mensajeOpcional,
    this.estadoPostulacion,
    this.fechaCreacion
});

  PropuestaPostulante.fromMap(Map snapshot, String id):
      id=id ?? '',
  idUserPostulante=snapshot['idUserPostulante'] ?? '',
  contraOfertaPresupuesto=snapshot['contraOfertaPresupuesto'] ?? 0,
  mensajeOpcional=snapshot['mensajeOpcional'] ?? '',
  estadoPostulacion=snapshot['estadoPostulacion'] ?? '',
  fechaCreacion= snapshot['fechaCreacion'] ?? null;

  toJson(){
    return{
      "idUserPostulante": idUserPostulante,
      "contraOfertaPresupuesto": contraOfertaPresupuesto,
      "mensajeOpcional": mensajeOpcional,
      "estadoPostulacion": estadoPostulacion,
      "fechaCreacion": fechaCreacion,
    };
  }

}