
import 'package:cloud_firestore/cloud_firestore.dart';

class Mensaje{
  String id;
  String contenidoMensaje;
  Timestamp fechaMensaje;
  String idUser;
  String otroUserToken;
  String userUrlImagenPerfil;
  String userNombre;

  Mensaje({
    this.id,
    this.contenidoMensaje,
    this.fechaMensaje,
    this.idUser,
    this.otroUserToken,
    this.userUrlImagenPerfil,
    this.userNombre
  });

  Mensaje.fromMap(Map snapshot, String id):
      id= id ?? '',
  contenidoMensaje= snapshot['contenidoMensaje'] ?? '',
  fechaMensaje=snapshot['fechaMensaje'] ?? null,
  idUser= snapshot['idUser'] ?? '',
  otroUserToken=snapshot['otroUserToken'] ?? '',
  userUrlImagenPerfil=snapshot['userUrlImagenPerfil'] ?? '',
  userNombre=snapshot['userNombre'] ?? '';

  toJson(){
    return{
      "contenidoMensaje": contenidoMensaje,
      "fechaMensaje": fechaMensaje,
      "idUser": idUser,
      "otroUserToken": otroUserToken,
      "userUrlImagenPerfil": userUrlImagenPerfil,
      "userNombre": userNombre,
    };
  }
}
