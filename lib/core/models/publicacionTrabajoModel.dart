

import 'package:cloud_firestore/cloud_firestore.dart';

class PublicacionTrabajo{
  String id;
  String idUser;
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
  String lugarTrabajo;

  PublicacionTrabajo({
    this.id,
    this.idUser,
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
    this.lugarTrabajo
});

  PublicacionTrabajo.fromMap(Map snapshot, String id):
      id= id ?? '',
  idUser=snapshot['idUser'] ?? '',
  nombreCategoria= snapshot['nombreCategoria'] ?? '',
  nombreSubcategoria= snapshot['nombreSubcategoria'] ?? '',
  titulo= snapshot['titulo'] ?? '',
  descripcion= snapshot['descripcion'] ?? '',
  habilidadesNecesarias= snapshot['habilidadesNecesarias'] ?? '',
  presupuesto= snapshot['presupuesto'] ?? '',
  razonDePago= snapshot['razonDePago'] ?? '',
  fechaCreacion= snapshot['fechaCreacion'] ?? null,
  fechaCreacionAlgolia=snapshot['fechaCreacionAlgolia'] ?? 0,
  fechaLimite= snapshot['fechaLimite'] ?? null,
  nivelImportancia= snapshot['nivelImportancia'] ?? 0,
  estadoPublicacionTrabajo= snapshot['estadoPublicacionTrabajo'] ?? '',
  lugarTrabajo= snapshot['lugarTrabajo'] ?? '';

  toJson(){
    return{
      "idUser": idUser,
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
      "lugarTrabajo": lugarTrabajo,
    };
  }



}