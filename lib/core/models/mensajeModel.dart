
import 'package:cloud_firestore/cloud_firestore.dart';

class Mensaje{
  String id;
  String contenidoMensaje;
  Timestamp fechaMensaje;
  String idUser;

  Mensaje({
    this.id,
    this.contenidoMensaje,
    this.fechaMensaje,
    this.idUser
  });

  Mensaje.fromMap(Map snapshot, String id):
      id= id ?? '',
  contenidoMensaje= snapshot['contenidoMensaje'] ?? '',
  fechaMensaje=snapshot['fechaMensaje'] ?? null,
  idUser= snapshot['idUser'] ?? '';

  toJson(){
    return{
      "contenidoMensaje": contenidoMensaje,
      "fechaMensaje": fechaMensaje,
      "idUser": idUser
    };
  }
}
