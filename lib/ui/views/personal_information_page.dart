import 'package:app/core/models/calificacionDeEmpleadoAEmpleador.dart';
import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/ui/views/marcar_lugar_residencia_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app/core/models/userModel.dart';
import 'package:date_format/date_format.dart';


class PersonalInformationPage extends StatefulWidget {
  final User user;
  PersonalInformationPage({Key key,this.user}) : super(key: key);

  @override
  _PersonalInformationPageState createState() {
    return _PersonalInformationPageState();
  }
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String tokenUser="";
  String fechaNacimientoFire="";
  var datosUbicacionLugarResidencia=Map();//array donde guardaremos los datos que devuelve la pagina de de google maps
  bool subiendoInformacionAFirebase=false;
  List<PropuestaPostulante> propuestas;
  List<CalificacionDeEmpleadoAEmpleador> calificacionesAEmpleador;

  final formatFechaNacimientoTextField= new DateFormat('dd-MM-yyyy');
  final formatFechaNacimientoForFire= new DateFormat('yyyy-MM-dd');

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController nombreCtrl= new TextEditingController();
  TextEditingController ciCtrl= new TextEditingController();
  TextEditingController fechaNacimientoCtrl= new TextEditingController();
  TextEditingController ciudadResienciaCtrl= new TextEditingController();
  TextEditingController telefonoCelularCtrl= new TextEditingController();
  TextEditingController correoElectronicoCtrl= new TextEditingController();


  @override
  void initState() {
    super.initState();
    cargarDatos();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getToken()async{
    tokenUser = await _fcm.getToken();
    print ("token User: "+ tokenUser);
  }


  Widget datetime() {
    return CupertinoDatePicker(
      initialDateTime: DateTime(DateTime.now().year-17,),
      onDateTimeChanged: (DateTime newdate) {
        print(newdate);
        fechaNacimientoCtrl.text=formatFechaNacimientoTextField.format(newdate);
        fechaNacimientoFire=formatFechaNacimientoForFire.format(newdate).toString();
      },
      minimumYear: DateTime.now().year-100,
      maximumYear: DateTime.now().year-17,
      mode: CupertinoDatePickerMode.date,
    );
  }
  cargarDatos(){
    nombreCtrl.text=widget.user.nombreCompleto;
    ciCtrl.text=widget.user.numCI;
    if(widget.user.fechaNacimiento!=null){
      fechaNacimientoCtrl.text=formatFechaNacimientoTextField.format(widget.user.fechaNacimiento.toDate());
      fechaNacimientoFire=formatFechaNacimientoForFire.format(widget.user.fechaNacimiento.toDate()).toString();
    }
    ciudadResienciaCtrl.text=widget.user.ciudadRecidencia;
    telefonoCelularCtrl.text=widget.user.telefonoCelular;
    correoElectronicoCtrl.text=widget.user.correoElectronico;
    if(widget.user.geoPoint!=null){
      datosUbicacionLugarResidencia['nombreLugar']=widget.user.ciudadRecidencia;
      datosUbicacionLugarResidencia['geoPoint']=widget.user.geoPoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCrudProvider=Provider.of<crudModel>(context);
    final loginState=Provider.of<LoginState>(context);

    

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Información personal",),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      body:
      Form(
        key: keyForm,
        child:
        ListView(
            padding: EdgeInsets.only(
                top: 5.0,
                right: 20.0,
                left: 20.0,
                bottom: 20
            ),

            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                  child: Row(
                   children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CircleAvatar(
                         radius: 40.0,
                         child: ClipOval( child: Image.network(widget.user.urlImagePerfil,width: 80,height: 80,fit: BoxFit.cover,),
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child: Column(
                         children: <Widget>[
                           Text("Calificaciones",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),),
                           SizedBox(height: 5.0,),
                           FutureBuilder(
                               future: userCrudProvider.getCalificacionesAEmpleador(widget.user.id),
                               builder: (context, calificacionesAEmpleadorSnap){
                                 if(calificacionesAEmpleadorSnap.connectionState==ConnectionState.waiting){
                                   return Center(
                                     child: Text("Cargando..."),
                                   );
                                 }
                                 else{
                                   calificacionesAEmpleador=calificacionesAEmpleadorSnap.data;
                                   num numeroDeCalificaciones=0;
                                   num sumaCalificaciones=0;
                                   calificacionesAEmpleador.asMap().forEach(( i, calificacion){
                                     if(calificacion.calificacionDeEmpleado !=0 ){
                                       numeroDeCalificaciones++;
                                       sumaCalificaciones=sumaCalificaciones+calificacion.calificacionDeEmpleado;
                                     }
                                   });
                                   return numeroDeCalificaciones==0?Text("Empleador: Sin calificaciones") :Text("Empleador: "+(sumaCalificaciones/numeroDeCalificaciones).toString()+"/10");
                                 }
                               }
                           ),
//                           Text("Empleador: 8/10",style: TextStyle(fontSize: 14.0) ),
                           SizedBox(height: 2.0,),
                           FutureBuilder(
                               future: userCrudProvider.getPostulaciones(widget.user.id),
                               builder: (context, postulacionesSnap){
                                 if(postulacionesSnap.connectionState==ConnectionState.waiting){
                                   return Center(
                                     child: Text("Cargando..."),
                                   );
                                 }
                                 else{
                                   propuestas=postulacionesSnap.data;
                                   num numeroDeCalificaciones=0;
                                   num sumaCalificaciones=0;
                                   propuestas.asMap().forEach(( i, propuesta){
                                     if(propuesta.calificacionAPostulanteGanador!=0 && propuesta.estadoPostulacion=="1"){
                                       numeroDeCalificaciones++;
                                       sumaCalificaciones=sumaCalificaciones+propuesta.calificacionAPostulanteGanador;
                                     }
                                   });
                                   return numeroDeCalificaciones==0?Text("Empleado: Sin calificaciones") :Text("Empleado: "+(sumaCalificaciones/numeroDeCalificaciones).toString()+"/10");
                                 }
                               }
                           ),
                         ],
                         crossAxisAlignment: CrossAxisAlignment.start,

                       ),
                     ),

                   ],
                    

                  ),
                ),
              ),
              SizedBox(height: 10.0,),
//            Container(
//              child: Center(
//                child: CircleAvatar(
//                  radius: 40.0,
//                  child: ClipOval( child: Image.network(widget.user.urlImagePerfil,width: 80,height: 80,fit: BoxFit.cover,),
//                  ),
//                ),
//              ),
//              padding: EdgeInsets.all(15),
//            ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Nombre completo",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: nombreCtrl,
                validator: validateNombre,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nro. de Cédula de Identidad",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(FontAwesomeIcons.addressCard),
                ),
                controller: ciCtrl,
                validator: validateCI,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Fecha de nacimiento",
//                  filled: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                            MediaQuery.of(context).copyWith().size.height /
                                3,
                            child: datetime());
                      }
                  );
                },
                readOnly: true,
                controller: fechaNacimientoCtrl,
                validator: validateFechaNacimiento,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Ciudad de residencia",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city)
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: ciudadResienciaCtrl,
                validator: validateCiudadRecidencia,
                readOnly: true,
                onTap: ()async{
                  if (await Permission.location.request().isGranted) {
                    var result=await Navigator.push(context, MaterialPageRoute(builder: (context)=> MarcarLugarResidenciaPage(datosUbicacionLugarResidencia: datosUbicacionLugarResidencia,)));
                    if(result!=null){
                      datosUbicacionLugarResidencia=result;
                      ciudadResienciaCtrl.text=datosUbicacionLugarResidencia['nombreLugar'];
                    }
                  }
                },
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Teléfono o celular",
//                    filled: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.call)
                ),
                keyboardType: TextInputType.number,
                controller: telefonoCelularCtrl,
                validator: validateTelefonoCelular,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Correo electrónico",
                    filled: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail)
                ),
                keyboardType: TextInputType.emailAddress,
                controller: correoElectronicoCtrl,
                validator: validateCorreoElectronico,
                readOnly: true,
              ),
              SizedBox(height: 15,),
              subiendoInformacionAFirebase?Center(child: CircularProgressIndicator(),):
              Container(
                child:
                RaisedButton(
                  color: Color.fromRGBO(63, 81, 181, 1),
                  child: Text("Guardar",style: TextStyle(fontSize: 18,color: Colors.white),),
                  onPressed: ()async{
//                    save();
                    if (keyForm.currentState.validate()) {
                      setState(() {subiendoInformacionAFirebase=true;});
                      print("Nombre ${nombreCtrl.text}");
                      print("CI ${ciCtrl.text}");
                      print("FechaNacimiento ${fechaNacimientoCtrl.text}");
                      print("CiudadResidencia ${ciudadResienciaCtrl.text}");
                      print("TelefonoCelular ${telefonoCelularCtrl.text}");
                      print("Correo ${correoElectronicoCtrl.text}");
//                      keyForm.currentState.reset();

                      DateTime fecha= DateTime.parse(fechaNacimientoFire);
                      print(fecha);

                      await userCrudProvider.updateUser(
                          User(
                            nombreCompleto: nombreCtrl.text,
                            numCI: ciCtrl.text,
                            fechaNacimiento: Timestamp.fromDate(fecha),
                            ciudadRecidencia: ciudadResienciaCtrl.text,
                            telefonoCelular: telefonoCelularCtrl.text,
                            correoElectronico: correoElectronicoCtrl.text,
                            urlImagePerfil: widget.user.urlImagePerfil,
                            urlDocumentCurriculum: widget.user.urlDocumentCurriculum,
                            idiomas: widget.user.idiomas,
                            estadoCuenta: widget.user.estadoCuenta,
                            habilidades: widget.user.habilidades,
                            nameDocCurriculum: widget.user.nameDocCurriculum,
                            token:tokenUser,
                            geoPoint: datosUbicacionLugarResidencia['geoPoint'],
                          ),
                          widget.user.id
                      );
                      await loginState.cargarInformacionPersonal(widget.user.id);
                      setState(() {subiendoInformacionAFirebase=false;});
                      Navigator.pop(context);

                    }
                    else{
                      print("El formulario tiene errores");
                    }
                  },
                  padding: EdgeInsets.all(10),
                ),
              )
            ],
          ),
      )
    );
  }

  String validateNombre(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre es requerido.";
    }
//    else if (!regExp.hasMatch(value)) {
//      return "El nombre no es válido.";
//    }
    return null;
  }

  String validateCI(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "El número de CI es requerido.";
    }
    else if (value.length<7) {
      return "El número de CI debe tener al menos 7 digitos";
    }
    return null;
  }

  String validateFechaNacimiento(String value) {
    if (value.length == 0) {
      return "La fecha de nacimiento es requerida.";
    }
    return null;
  }

  String validateCiudadRecidencia(String value) {
//    String pattern = r'(^[a-zA-Z ]*$)';
//    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre de la Ciudad es requerido.";
    }
//    else if (!regExp.hasMatch(value)) {
//      return "El nombre de la Ciudad no es válido";
//    }
    return null;
  }

  String validateTelefonoCelular(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "El teléfono es requerido.";
    } else if (value.length < 5 ) {
      return "El numero debe tener al menos 5 dígitos";
    }
    return null;
  }

  String validateCorreoElectronico(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El correo es requerido.";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      return null;
    }
  }

  save() {
    if (keyForm.currentState.validate()) {
      print("Nombre ${nombreCtrl.text}");
      print("CI ${ciCtrl.text}");
      print("FechaNacimiento ${fechaNacimientoCtrl.text}");
      print("CiudadResidencia ${ciudadResienciaCtrl.text}");
      print("TelefonoCelular ${telefonoCelularCtrl.text}");
      print("Correo ${correoElectronicoCtrl.text}");
      keyForm.currentState.reset();
    }
    else{
      print("El formulario tiene errores");
    }
  }
}