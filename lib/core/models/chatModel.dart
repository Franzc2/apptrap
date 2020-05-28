import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  String id;
  List idsChat;
  List idsUsers;
  String idUser1;
  String idUser2;
  Timestamp fechaUltimoMensaje;
  num numeroMensajesNuevosParaIdUser1;
  num numeroMensajesNuevosParaIdUser2;

  Chat({
    this.id,
    this.idsChat,
    this.idsUsers,
    this.idUser1,
    this.idUser2,
    this.fechaUltimoMensaje,
    this.numeroMensajesNuevosParaIdUser1,
    this.numeroMensajesNuevosParaIdUser2
  });

  Chat.fromMap(Map snapshot,String id):
      id= id ?? '',
  idsChat= snapshot['idsChat'] ?? [],
  idsUsers= snapshot['idsUsers'] ?? [],
  idUser1=snapshot['idUser1'] ?? '',
  idUser2=snapshot['idUser2'] ?? '',
  fechaUltimoMensaje= snapshot['fechaUltimoMensaje'] ?? null,
  numeroMensajesNuevosParaIdUser1= snapshot['numeroMensajesNuevosParaIdUser1'] ?? 0,
  numeroMensajesNuevosParaIdUser2= snapshot['numeroMensajesNuevosParaIdUser2'] ?? 0;

  toJson(){
    return{
      "idsChat": idsChat,
      "idsUsers": idsUsers,
      "idUser1": idUser1,
      "idUser2": idUser2,
      "fechaUltimoMensaje": fechaUltimoMensaje,
      "numeroMensajesNuevosParaIdUser1": numeroMensajesNuevosParaIdUser1,
      "numeroMensajesNuevosParaIdUser2": numeroMensajesNuevosParaIdUser2
    };
  }
}