import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria{
  String id;
  String nombreCategoria;
  List<String> subCategorias;

  Categoria({
    this.id,
    this.nombreCategoria,
    this.subCategorias
  });

  Categoria.fromMap(Map snapshot, String id):
      id=id ?? '',
  nombreCategoria=snapshot['nombreCategoria'] ?? '',
  subCategorias=List.from(snapshot['subCategorias']) ?? [];

  toJson(){
    return{
      "nombreCategoria": nombreCategoria,
      "subCategorias": subCategorias
    };
  }
}