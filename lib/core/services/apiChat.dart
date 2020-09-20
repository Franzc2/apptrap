
import 'package:app/core/models/chatModel.dart';
import 'package:app/core/models/mensajeModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiChat{
  final Firestore _db=Firestore.instance;
  final String path;
  CollectionReference ref;

  ApiChat(this.path){
    ref=_db.collection(this.path);
  }

  Stream<QuerySnapshot> streamChatsUser(String idUser){
    return ref.where('idsUsers',arrayContains: idUser).orderBy('fechaUltimoMensaje',descending: true).snapshots(); //snapshots();
  }

  Stream<QuerySnapshot> streamMensajesChat(String idChat){
    return ref.document(idChat).collection('mensajes').orderBy('fechaMensaje',descending: true).snapshots();
  }

  /// Cada vez que ingresamos a un chat llama a la funcion para vaciarlo
  Stream<QuerySnapshot> streamMensajesChat1(String idUser,String idChat){
    operacionesStreamMensajesChat1(idUser, idChat);
    return ref.document(idChat).collection('mensajes').orderBy('fechaMensaje',descending: true).snapshots();
  }

  Future<void> addChat(String idChat,Map data){
    return ref.document(idChat).setData(data);
  }
  Future<DocumentReference> addMensaje(String idChat, Map data, Mensaje mensaje){
    operacionesAddMensaje(idChat, data, mensaje);
    return ref.document(idChat).collection('mensajes').add(data);
  }

  void operacionesAddMensaje(String idChat, Map data, Mensaje mensaje)async{
    var doc= await getCharById(idChat);
    Chat chat=Chat.fromMap(doc.data, doc.documentID);
    if(chat.idUser1==mensaje.idUser){
      chat.numeroMensajesNuevosParaIdUser2=chat.numeroMensajesNuevosParaIdUser2+1;
    }
    else{
      chat.numeroMensajesNuevosParaIdUser1=chat.numeroMensajesNuevosParaIdUser1+1;
    }
    chat.fechaUltimoMensaje=mensaje.fechaMensaje;
    updateChat(chat.toJson(), chat.id);
  }
  // sirve para vaciar el conteo de chat.
  void operacionesStreamMensajesChat1(String idUser,String idChat)async{
    var doc= await getCharById(idChat);
    Chat chat=Chat.fromMap(doc.data, doc.documentID);
    if(chat.idUser1==idUser){
      chat.numeroMensajesNuevosParaIdUser1=0;
    }
    else{
      chat.numeroMensajesNuevosParaIdUser2=0;
    }
    updateChat(chat.toJson(), chat.id);
  }

  Future<DocumentSnapshot> getCharById(String idChat) {
    return ref.document(idChat).get();
  }
  Future<void> updateChat(Map data , String idChat) {
    return ref.document(idChat).updateData(data) ;
  }

  Future<DocumentSnapshot> getChat(String _idUser, String _idOtroUser)async{
    QuerySnapshot resul= await ref.where('idsChat',arrayContains: _idUser+_idOtroUser).limit(1).getDocuments();
    if(resul.documents.length==0){
      await addChat(
        _idUser+_idOtroUser,
          Chat(
            idUser1: _idUser,
            idUser2: _idOtroUser,
            fechaUltimoMensaje: null,
            numeroMensajesNuevosParaIdUser1: 0,
            numeroMensajesNuevosParaIdUser2: 0,
            idsUsers: [_idUser,_idOtroUser],
            idsChat: [_idUser+_idOtroUser,_idOtroUser+_idUser]
          ).toJson()
      );
      DocumentSnapshot docChat= await ref.document(_idUser+_idOtroUser).get();
      return docChat;
    }
    else{
      return resul.documents.first;
    }
  }






}