

import 'package:cloud_firestore/cloud_firestore.dart';

class PublicacionTrabajoAlgolia{
  String id;
  String idUser;
  String nombreCategoria;
  String nombreSubcategoria;
  String titulo;
  String descripcion;
  String habilidadesNecesarias;
  num presupuesto;
  String razonDePago;
  timestamp fechaCreacion;
  num fechaCreacionAlgolia;
  timestamp fechaLimite;
  num nivelImportancia;
  String estadoPublicacionTrabajo;
  String lugarTrabajo;

  PublicacionTrabajoAlgolia({
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

//  factory PublicacionTrabajoAlgolia.fromJson(Map<String, dynamic> parsedJson){
  factory PublicacionTrabajoAlgolia.fromJson(Map parsedJson,String id){
    return PublicacionTrabajoAlgolia(
        id: id,
        idUser: parsedJson['idUser'],
        nombreCategoria: parsedJson['nombreCategoria'],
        nombreSubcategoria: parsedJson['nombreSubcategoria'],
        titulo: parsedJson['titulo'],
        descripcion: parsedJson['descripcion'],
        habilidadesNecesarias: parsedJson['habilidadesNecesarias'],
        presupuesto: parsedJson['presupuesto'],
        razonDePago: parsedJson['razonDePago'],
        fechaCreacion: timestamp.fromJson(parsedJson['fechaCreacion']),
        fechaCreacionAlgolia: parsedJson['fechaCreacionAlgolia'],
        fechaLimite: timestamp.fromJson(parsedJson['fechaLimite']),
        nivelImportancia: parsedJson['nivelImportancia'],
        estadoPublicacionTrabajo: parsedJson['estadoPublicacionTrabajo'],
        lugarTrabajo: parsedJson['lugarTrabajo']
    );
  }

//  PublicacionTrabajoAlgolia.fromMap(Map snapshot, String id):
//        id= id ?? '',
//        idUser=snapshot['idUser'] ?? '',
//        nombreCategoria= snapshot['nombreCategoria'] ?? '',
//        nombreSubcategoria= snapshot['nombreSubcategoria'] ?? '',
//        titulo= snapshot['titulo'] ?? '',
//        descripcion= snapshot['descripcion'] ?? '',
//        habilidadesNecesarias= snapshot['habilidadesNecesarias'] ?? '',
//        presupuesto= snapshot['presupuesto'] ?? '',
//        razonDePago= snapshot['razonDePago'] ?? '',
//        fechaCreacion= snapshot['fechaCreacion'] ?? [],
//        fechaCreacionAlgolia=snapshot['fechaCreacionAlgolia'] ?? 0,
//        fechaLimite= snapshot['fechaLimite'] ?? [],
//        nivelImportancia= snapshot['nivelImportancia'] ?? 0,
//        estadoPublicacionTrabajo= snapshot['estadoPublicacionTrabajo'] ?? '';

//  toJson(){
//    return{
//      "idUser": idUser,
//      "nombreCategoria": nombreCategoria,
//      "nombreSubcategoria": nombreSubcategoria,
//      "titulo": titulo,
//      "descripcion": descripcion,
//      "habilidadesNecesarias": habilidadesNecesarias,
//      "presupuesto": presupuesto,
//      "razonDePago": razonDePago,
//      "fechaCreacion": fechaCreacion,
//      "fechaCreacionAlgolia": fechaCreacionAlgolia,
//      "fechaLimite": fechaLimite,
//      "nivelImportancia": nivelImportancia,
//      "estadoPublicacionTrabajo": estadoPublicacionTrabajo,
//    };
//  }
}

class timestamp{
  num seconds;
  num nanoseconds;

  timestamp({
    this.seconds,
    this.nanoseconds,
  })
//      :_seconds=seconds, _nanoseconds=nanoseconds
  ;

  factory timestamp.fromJson(Map<String,dynamic> json){
    return timestamp(
      seconds: json['_seconds'],
      nanoseconds: json['_nanoseconds']
    );
  }
}