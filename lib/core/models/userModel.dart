
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String id;
  String nombreCompleto;
  String numCI;
  String ciudadRecidencia;
  String telefonoCelular;
  String correoElectronico;
  Timestamp fechaNacimiento;
  String urlImagePerfil;
  List<String> habilidades;
  List<String> idiomas;
  String urlDocumentCurriculum;
  String estadoCuenta;
  String nameDocCurriculum;


  User({
    this.id,
    this.nombreCompleto,
    this.numCI,
    this.ciudadRecidencia,
    this.telefonoCelular,
    this.correoElectronico,
    this.fechaNacimiento,
    this.urlImagePerfil,
    this.habilidades,
    this.idiomas,
    this.urlDocumentCurriculum,
    this.estadoCuenta,
    this.nameDocCurriculum
  });

  User.fromMap(Map snapshot, String id):
      id=id ?? '',
      nombreCompleto=snapshot['nombreCompleto'] ?? '',
      numCI=snapshot['numCI'] ?? '',
      ciudadRecidencia=snapshot['ciudadRecidencia'] ?? '',
      telefonoCelular=snapshot['telefonoCelular'] ?? '',
      correoElectronico=snapshot['correoElectronico'] ?? '',
      fechaNacimiento=snapshot['fechaNacimiento'] ?? null,
      urlImagePerfil=snapshot['urlImagePerfil'] ?? '',
      habilidades=List.from(snapshot['habilidades'] ?? []),
      idiomas=List.from(snapshot['idiomas'] ?? []),
      urlDocumentCurriculum=snapshot['urlDocumentCurriculum'] ?? '',
      estadoCuenta=snapshot['estadoCuenta'] ?? '',
      nameDocCurriculum=snapshot['nameDocCurriculum'] ?? '';


  toJson() {
    return {
    "nombreCompleto": nombreCompleto,
    "numCI": numCI,
    "ciudadRecidencia": ciudadRecidencia,
    "telefonoCelular": telefonoCelular,
    "correoElectronico": correoElectronico,
    "fechaNacimiento": fechaNacimiento,
    "urlImagePerfil": urlImagePerfil,
    "habilidades": habilidades,
    "idiomas": idiomas,
    "urlDocumentCurriculum": urlDocumentCurriculum,
    "estadoCuenta": estadoCuenta,
    "nameDocCurriculum": nameDocCurriculum
    };
  }
}