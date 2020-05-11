import 'dart:async';
import 'package:app/core/models/categoriaPublicacionModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/services/apiCategoriaPublicacion.dart';
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

  List<User> users;
  List<ExpProfesional> expProfUser;
  List<Formacion> formacionUser;
  List<Categoria> categorias;
  List<PublicacionTrabajoUser> publicacionesUser;

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
  Future addPublicacionUser(String idDocUserCollection, PublicacionTrabajoUser data )async{
    var result= await _api.addDocumentInSubCollectionPublication(idDocUserCollection, 'publicacion_trabajo', data.toJson());
    return ;
  }
  Future editPublicacionUser(String idDocUserCollection,String idDocSubCollection, PublicacionTrabajoUser data)async{
    var result= await _api.updateDocumentInSubCollectionPublication(idDocUserCollection, 'publicacion_trabajo', idDocSubCollection, data.toJson());
    return ;
  }

  Future deletePublicacionUser(String idDocUserCollection,String idDocSubCollection)async{
    var result= await _api.removeDocumentFromSubCollectionByIdPublication(idDocUserCollection, 'publicacion_trabajo', idDocSubCollection);
    return ;
  }

  Future<List<PublicacionTrabajoUser>> getPublicacionesUser(String idDocUserCollection)async{
    var result= await _api.getDataSubCollection(idDocUserCollection, 'publicacion_trabajo').catchError((e)=>print(e));
    publicacionesUser=result.documents
        .map((doc) => PublicacionTrabajoUser.fromMap(doc.data, doc.documentID))
        .toList();
    return publicacionesUser;
  }

  Future<PublicacionTrabajoUser> getPublicacionTrabajoById(String idDocUserCollection, String idDocPublicacionTrabajo) async {
    var doc = await _api.getDocumentFromSubCollectionById(idDocUserCollection, 'publicacion_trabajo', idDocPublicacionTrabajo) ;
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

// Publicaciones General---Todos los usuarios---------------------------------------------------------------------------------------



// ---------------------------------------------------------------------------------------------------------------------------------



}