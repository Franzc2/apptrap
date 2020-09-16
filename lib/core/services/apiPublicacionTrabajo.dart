import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ApiPublicacionTrabajo{
  final Firestore _db=Firestore.instance;
  final String path;
  CollectionReference ref;

  ApiPublicacionTrabajo(this.path){ //this.path=> publicaciones
    ref=_db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments() ;
  }

  Future<void> addDocumentPublicacion(Map data, String uid) {
    return ref.document(uid).setData(data);
  }
  Future<void> updateDocumentPublicacion(Map data , String id) {
    return ref.document(id).updateData(data) ;
  }
  Future<void> removeDocumentPublicacion(String id){
    return ref.document(id).delete();
  }

}