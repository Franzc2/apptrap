import 'package:cloud_firestore/cloud_firestore.dart';

class Formacion{
  String id;
  Timestamp fechaCreacion;
  String institucion;
  String nivelEstudios;
  String estadoActualFormacion;
  Timestamp fechaInicio;
  Timestamp fechaFin;


  Formacion({
    this.id,
    this.fechaCreacion,
    this.institucion,
    this.nivelEstudios,
    this.estadoActualFormacion,
    this.fechaInicio,
    this.fechaFin,

  });

  Formacion.fromMap(Map snapshot, String id):
        id= id ?? '',
        fechaCreacion= snapshot['fechaCreacion'] ?? null,
        institucion= snapshot['institucion'] ?? '',
        nivelEstudios= snapshot['nivelEstudios'] ?? '',
        estadoActualFormacion= snapshot['estadoActualFormacion'] ?? '',
        fechaInicio= snapshot['fechaInicio'] ?? null,
        fechaFin= snapshot['fechaFin'] ?? null;

  toJson(){
    return{
      "fechaCreacion": fechaCreacion,
      "institucion": institucion,
      "nivelEstudios": nivelEstudios,
      "estadoActualFormacion": estadoActualFormacion,
      "fechaInicio": fechaInicio,
      "fechaFin":fechaFin,
    };
  }

}



