import 'package:app/core/models/categoriaPublicacionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ApiCategoriaPublicacion{
  final Firestore _db=Firestore.instance;
  final String path;
  CollectionReference ref;

  ApiCategoriaPublicacion(this.path){
    ref= _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollectionCategorias(){
    return ref.getDocuments();
  }
}