import 'package:cloud_firestore/cloud_firestore.dart';

class PropuestaPostulante{
  String id;
  String idUserPostulante;
  String idUserPublicante;
  String idPublicacionTrabajoUserPublicante;
  num contraOfertaPresupuesto;
  String mensajeOpcional;
  String estadoPostulacion;
  Timestamp fechaCreacion;
  String categoriaPublicacionTrabajo;
  String subCategoriaPublicacionTrabajo;
  String tituloPublicacionTrabajo;


  PropuestaPostulante({
    this.id,
    this.idUserPostulante,
    this.idUserPublicante,
    this.idPublicacionTrabajoUserPublicante,
    this.contraOfertaPresupuesto,
    this.mensajeOpcional,
    this.estadoPostulacion,
    this.fechaCreacion,
    this.categoriaPublicacionTrabajo,
    this.subCategoriaPublicacionTrabajo,
    this.tituloPublicacionTrabajo,
});

  PropuestaPostulante.fromMap(Map snapshot, String id):
      id=id ?? '',
  idUserPostulante=snapshot['idUserPostulante'] ?? '',
  idUserPublicante=snapshot['idUserPublicante'] ?? '',
  idPublicacionTrabajoUserPublicante=snapshot['idPublicacionTrabajoUserPublicante'] ?? '',
  contraOfertaPresupuesto=snapshot['contraOfertaPresupuesto'] ?? 0,
  mensajeOpcional=snapshot['mensajeOpcional'] ?? '',
  estadoPostulacion=snapshot['estadoPostulacion'] ?? '',
  fechaCreacion= snapshot['fechaCreacion'] ?? null,
  categoriaPublicacionTrabajo= snapshot['categoriaPublicacionTrabajo'] ?? '',
  subCategoriaPublicacionTrabajo=snapshot['subCategoriaPublicacionTrabajo'] ?? '',
  tituloPublicacionTrabajo=snapshot['tituloPublicacionTrabajo'] ?? '';

  toJson(){
    return{
      "idUserPostulante": idUserPostulante,
      "idUserPublicante": idUserPublicante,
      "idPublicacionTrabajoUserPublicante":idPublicacionTrabajoUserPublicante,
      "contraOfertaPresupuesto": contraOfertaPresupuesto,
      "mensajeOpcional": mensajeOpcional,
      "estadoPostulacion": estadoPostulacion,
      "fechaCreacion": fechaCreacion,
      'categoriaPublicacionTrabajo': categoriaPublicacionTrabajo,
      'subCategoriaPublicacionTrabajo': subCategoriaPublicacionTrabajo,
      'tituloPublicacionTrabajo': tituloPublicacionTrabajo
    };
  }

}