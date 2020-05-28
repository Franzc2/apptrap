import 'dart:async';
import 'package:app/core/models/categoriaPublicacionModel.dart';
import 'package:app/core/models/chatModel.dart';
import 'package:app/core/models/mensajeModel.dart';
import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/services/apiCategoriaPublicacion.dart';
import 'package:app/core/services/apiChat.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../services/apiUser.dart';
import '../models/userModel.dart';
import '../models/expProfesionalModel.dart';
import '../models/formacionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class crudModel extends ChangeNotifier{
  ApiUser _api= locator<ApiUser>();
  ApiCategoriaPublicacion _apiCategoriaPublicacon= locator<ApiCategoriaPublicacion>();
  ApiChat _apiChat=locator<ApiChat>();

  List<User> users;
  List<ExpProfesional> expProfUser;
  List<Formacion> formacionUser;
  List<Categoria> categorias;
  List<PublicacionTrabajoUser> publicacionesUser;
  List<PropuestaPostulante> propuestasPostulantes;
  List<PropuestaPostulante> postulaciones;

  Future<List<User>> fetchUsers() async{
    var result = await _api.getDataCollection();
    users = result.documents
        .map((doc) => User.fromMap(doc.data, doc.documentID))
        .toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  Future<User> getUserById(String id) async {
    var doc = await _api.getDocumentById(id);
    if(doc.exists){
      return  User.fromMap(doc.data, doc.documentID);
    }
    else{ return null; }
  }



  Future removeProduct(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }
  Future updateUser(User data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addUser(User data,String uid) async{
    var result  = await _api.addDocument(data.toJson(),uid) ;
    return ;
  }

  Stream<QuerySnapshot> fetchExperienceProfUserAsStream(String idDocUserCollection) {
    return _api.streamDataSubCollection(idDocUserCollection, 'experiencia_profesional');
  }

  Stream<QuerySnapshot> fetchFormacionUserAsStream(String idDocCollection) {
    return _api.streamDataSubCollection(idDocCollection, 'formacion');
  }
// Experiencia Profesional----------------------------------------------------------------------------------------------------------
  Future addExpProfUser(String idDocUserCollection, ExpProfesional data )async{
    var result= await _api.addDocumentInSubCollection(idDocUserCollection, 'experiencia_profesional', data.toJson());
    return ;
  }

  Future editExpProfUser(String idDocUserCollection,String idDocSubCollection, ExpProfesional data)async{
    var result= await _api.updateDocumentInSubCollection(idDocUserCollection, 'experiencia_profesional', idDocSubCollection, data.toJson());
    return ;
  }

  Future deleteExpProfUser(String idDocUserCollection,String idDocSubCollection)async{
    var result= await _api.removeDocumentFromSubCollectionById(idDocUserCollection, 'experiencia_profesional', idDocSubCollection);
    return ;
  }

  Future<List<ExpProfesional>> getExperienceProfUser(String idDocUserCollection)async{
    var result= await _api.getDataSubCollection(idDocUserCollection, 'experiencia_profesional');
    expProfUser=result.documents
        .map((doc) => ExpProfesional.fromMap(doc.data, doc.documentID))
        .toList();
    return expProfUser;
  }
// ---------------------------------------------------------------------------------------------------------------------------------

// Formacion Profesional------------------------------------------------------------------------------------------------------------
  Future addFormacionUser(String idDocUserCollection, Formacion data )async{
    var result= await _api.addDocumentInSubCollection(idDocUserCollection, 'formacion', data.toJson());
    return ;
  }

  Future editFormacionUser(String idDocUserCollection,String idDocSubCollection, Formacion data)async{
    var result= await _api.updateDocumentInSubCollection(idDocUserCollection, 'formacion', idDocSubCollection, data.toJson());
    return ;
  }

  Future deleteFormacionUser(String idDocUserCollection,String idDocSubCollection)async{
    var result= await _api.removeDocumentFromSubCollectionById(idDocUserCollection, 'formacion', idDocSubCollection);
    return ;
  }

  Future<List<Formacion>> getFormacionUser(String idDocUserCollection)async{
    var result= await _api.getDataSubCollection(idDocUserCollection, 'formacion');
    formacionUser=result.documents
        .map((doc) => Formacion.fromMap(doc.data, doc.documentID))
        .toList();
    return formacionUser;
  }
// ---------------------------------------------------------------------------------------------------------------------------------

  // Publicaiones de usuarios----------------------------------------------------------------------------------------------------------
  Future addPublicacionUser(String idDocUserCollection, PublicacionTrabajoUser data,User dataUserPublicador )async{
    var result= await _api.addDocumentInSubCollectionPublication(idDocUserCollection, 'publicaciones_trabajos', data.toJson(), dataUserPublicador);
    return ;
  }
  Future editPublicacionUser(String idDocUserCollection,String idDocSubCollection, PublicacionTrabajoUser data)async{
    var result= await _api.updateDocumentInSubCollectionPublication(idDocUserCollection, 'publicaciones_trabajos', idDocSubCollection, data.toJson());
    return ;
  }

  Future deletePublicacionUser(String idDocUserCollection,String idDocSubCollection)async{
    var result= await _api.removeDocumentFromSubCollectionByIdPublication(idDocUserCollection, 'publicaciones_trabajos', idDocSubCollection);
    return ;
  }

  Future<List<PublicacionTrabajoUser>> getPublicacionesUser(String idDocUserCollection)async{
    var result= await _api.getDataSubCollection(idDocUserCollection, 'publicaciones_trabajos').catchError((e)=>print(e));
    publicacionesUser=result.documents
        .map((doc) => PublicacionTrabajoUser.fromMap(doc.data, doc.documentID))
        .toList();
    return publicacionesUser;
  }

  Future<PublicacionTrabajoUser> getPublicacionTrabajoById(String idDocUserCollection, String idDocPublicacionTrabajo) async {
    var doc = await _api.getDocumentFromSubCollectionById(idDocUserCollection, 'publicaciones_trabajos', idDocPublicacionTrabajo) ;
    if(doc.exists){
      return  PublicacionTrabajoUser.fromMap(doc.data, doc.documentID);
    }
    else{ return null; }
  }

// ---------------------------------------------------------------------------------------------------------------------------------


// Categorias de Publicaciones------------------------------------------------------------------------------------------------------

  Future<List<Categoria>> getCategorias() async{
    var result = await _apiCategoriaPublicacon.getDataCollectionCategorias();
        categorias = result.documents
        .map((doc) => Categoria.fromMap(doc.data, doc.documentID))
        .toList();
    return categorias;
  }
// ---------------------------------------------------------------------------------------------------------------------------------

// Propuesta postulante---------------------------------------------------------------------------------------

  Future addPropuestaPostulante(String idDocUserCollection,String idDocPublicacionTrabajo, PropuestaPostulante data,String idUserPostulante )async{
    var result= await _api.addDocumentInSubCollection2PropuestaPostulante(
        idDocUserCollection,
        'publicaciones_trabajos',
        idDocPublicacionTrabajo,
        'propuestas_postulantes',
        data.toJson(),
        idUserPostulante
    );
    return ;
  }

  Future<List<PropuestaPostulante>> getPropuestasPostulantesTrabajo(String idDocUserCollection,String idDocPublicacionTrabajo)async{
    var result= await _api.getDataSubCollection2(idDocUserCollection, 'publicaciones_trabajos',idDocPublicacionTrabajo,"propuestas_postulantes").catchError((e)=>print(e));
    propuestasPostulantes=result.documents
        .map((doc) => PropuestaPostulante.fromMap(doc.data, doc.documentID))
        .toList();
    return propuestasPostulantes;
  }

  Future<List<PropuestaPostulante>> getPostulaciones(String idDocUserCollection)async{
    var result= await _api.getDataSubCollection(idDocUserCollection, 'postulaciones',).catchError((e)=>print(e));
    postulaciones=result.documents
        .map((doc) => PropuestaPostulante.fromMap(doc.data, doc.documentID))
        .toList();
    return postulaciones;
  }

// ---------------------------------------------------------------------------------------------------------------------------------

  Future<Chat> getChat(String idUser,String idOtroUser) async {
    var doc = await _apiChat.getChat(idUser, idOtroUser);
    if(doc==null){
      return null;
    }
    else{
      return  Chat.fromMap(doc.data, doc.documentID);
    }
  }

  Stream<QuerySnapshot> mensajesChatStream(String idChat) {
    return _apiChat.streamMensajesChat(idChat);
  }

  Stream<QuerySnapshot> mensajesChatStream1(String idUser,String idChat) {
    return _apiChat.streamMensajesChat1(idUser,idChat);
  }

  Future addMensaje(String idChat, Mensaje data)async{
    var result = await _apiChat.addMensaje(idChat, data.toJson(),data);
    return;
  }

  Stream<QuerySnapshot> streamChatsUser(String idUser){
    return _apiChat.streamChatsUser(idUser);
  }

}