import 'package:cloud_firestore/cloud_firestore.dart';

class PublicacionTrabajoUser{
  String id;
  String nombreCategoria;
  String nombreSubcategoria;
  String titulo;
  String descripcion;
  String habilidadesNecesarias;
  num presupuesto;
  String razonDePago;
  Timestamp fechaCreacion;
  num fechaCreacionAlgolia;
  Timestamp fechaLimite;
  num nivelImportancia;
  String estadoPublicacionTrabajo;
  String modalidadDeTrabajo;
  String urlImagePublicacion;
  String urlImageComprobantePago;

  PublicacionTrabajoUser({
    this.id,
    this.nombreCategoria,
    this.nombreSubcategoria,
    this.titulo,
    this.descripcion,
    this.habilidadesNecesarias,
    this.presupuesto,
    this.razonDePago,
    this.fechaCreacion,
    this.fechaCreacionAlgolia,
    this.fechaLimite,
    this.nivelImportancia,
    this.estadoPublicacionTrabajo,
    this.modalidadDeTrabajo,
    this.urlImagePublicacion,
    this.urlImageComprobantePago
  });

  PublicacionTrabajoUser.fromMap(Map snapshot, String id):
        id= id ?? '',
        nombreCategoria= snapshot['nombreCategoria'] ?? '',
        nombreSubcategoria= snapshot['nombreSubcategoria'] ?? '',
        titulo= snapshot['titulo'] ?? '',
        descripcion= snapshot['descripcion'] ?? '',
        habilidadesNecesarias= snapshot['habilidadesNecesarias'] ?? '',
        presupuesto= snapshot['presupuesto'] ?? 0,
        razonDePago= snapshot['razonDePago'] ?? '',
        fechaCreacion= snapshot['fechaCreacion'] ?? null,
        fechaCreacionAlgolia= snapshot['fechaCreacionAlgolia'] ?? 0,
        fechaLimite= snapshot['fechaLimite'] ?? null,
        nivelImportancia= snapshot['nivelImportancia'] ?? 0,
        estadoPublicacionTrabajo= snapshot["estadoPublicacionTrabajo"] ?? '',
        modalidadDeTrabajo= snapshot["modalidadDeTrabajo"] ?? '',
        urlImagePublicacion = snapshot['urlImagePublicacion'] ?? '',
        urlImageComprobantePago=snapshot['urlImageComprobantePago'] ?? '';


  toJson(){
    return{
      "nombreCategoria": nombreCategoria,
      "nombreSubcategoria": nombreSubcategoria,
      "titulo": titulo,
      "descripcion": descripcion,
      "habilidadesNecesarias": habilidadesNecesarias,
      "presupuesto": presupuesto,
      "razonDePago": razonDePago,
      "fechaCreacion": fechaCreacion,
      "fechaCreacionAlgolia": fechaCreacionAlgolia,
      "fechaLimite": fechaLimite,
      "nivelImportancia": nivelImportancia,
      "estadoPublicacionTrabajo": estadoPublicacionTrabajo,
      "modalidadDeTrabajo": modalidadDeTrabajo,
      "urlImagePublicacion": urlImagePublicacion,
      "urlImageComprobantePago": urlImageComprobantePago
    };
  }
}


