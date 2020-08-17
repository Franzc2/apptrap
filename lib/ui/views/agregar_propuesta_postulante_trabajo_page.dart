import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/publicacionTrabajoAlgoliaModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';

class AgregarPropuestaPostulanteTrabajoPage extends StatefulWidget {
  final PublicacionTrabajoAlgolia publicacionTrabajoAlgolia;
  AgregarPropuestaPostulanteTrabajoPage({Key key,this.publicacionTrabajoAlgolia}) : super(key: key);

  @override
  _AgregarPropuestaPostulanteTrabajoPageState createState() {
    return _AgregarPropuestaPostulanteTrabajoPageState();
  }
}

class _AgregarPropuestaPostulanteTrabajoPageState extends State<AgregarPropuestaPostulanteTrabajoPage> {
  GlobalKey<ScaffoldState> _scaffoldKey=new GlobalKey();
  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController presupuestoCtrl= new TextEditingController();
  TextEditingController mensajeCtrl= new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _crud= Provider.of<crudModel>(context);
    final User infoUser=Provider.of<LoginState>(context).infoUser();
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
          title: Text(widget.publicacionTrabajoAlgolia.titulo),
        ),
//        floatingActionButton: FloatingActionButton.extended(
//          onPressed: (){
//            Navigator.push(context, MaterialPageRoute(builder: (_)=> AgregarPropuestaPostulanteTrabajoPage(publicacionTrabajoAlgolia:widget.publicacionTrabajoAlgolia,)));
//          },
//          label: Text("Enviar propuesta"),
//          icon: Icon(Icons.send),
//          backgroundColor: Color.fromRGBO(255, 193, 7, 1),
//        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          color: Color.fromRGBO(189, 189, 189, 0.01),

          child: FutureBuilder(
            future: _crud.getUserById(widget.publicacionTrabajoAlgolia.idUserPublicador),
            builder: (_, userSnap){
              if(userSnap.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else{
                if(userSnap.data==null){
                  return
                    Center(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 40,),
                          Icon(Icons.error,size: 120.0,color: Color.fromRGBO(197, 202, 232, 1.0),),
                          SizedBox(height: 10,),
                          Center(
                            child: Text("Error al cargar la información.",style: TextStyle(color: Colors.black38),),
                          ),
                        ],
                      ),
                    );
                }
                else{
                  User user=userSnap.data;
                  return
                    Form(
                      key: keyForm,
                      child: ListView(
                        padding: EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0, bottom: 30.0),
                        children: <Widget>[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                RichText(
                                    text:TextSpan(
                                      style: new TextStyle(fontSize: 14.0,color: Colors.black87),
                                      children: <TextSpan>[
                                        new TextSpan(
                                          text: "Lugar de Trabajo: ",
                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)
                                        ),
                                        new TextSpan(text: widget.publicacionTrabajoAlgolia.modalidadDeTrabajo)
                                      ]
                                    )
                                ),
                                  SizedBox(height: 5.0,),
                                  RichText(
                                      text:TextSpan(
                                          style: new TextStyle(fontSize: 14.0,color: Colors.black87),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Presupuesto: ",
                                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)
                                            ),
                                            new TextSpan(text: widget.publicacionTrabajoAlgolia.presupuesto.toString()+" Bs.")
                                          ]
                                      )
                                  ),
                                  SizedBox(height: 5.0,),
                                  RichText(
                                      text:TextSpan(
                                          style: new TextStyle(fontSize: 14.0,color: Colors.black87),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text: "Razón de pago: ",
                                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)
                                            ),
                                            new TextSpan(text: widget.publicacionTrabajoAlgolia.razonDePago)
                                          ]
                                      )
                                  ),
                                  SizedBox(height: 5.0,),
//                                Text("Publicado: "+_formatPublicacion.format(DateTime.fromMillisecondsSinceEpoch(widget.publicacionTrabajoAlgolia.fechaCreacionAlgolia*1000)))
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            elevation: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("PROPUESTA",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,fontSize: 15.0),),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text(widget.publicacionTrabajoAlgolia.razonDePago,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                                  SizedBox(height: 5.0,),
                                  TextFormField(
                                    decoration: const InputDecoration(
//                                      labelText: "Presupuesto",
                                        border: OutlineInputBorder(),
                                        suffixText: 'Bs.'
                                    ),
                                    keyboardType:TextInputType.number,
                                    inputFormatters: [
                                      ThousandsFormatter()
                                    ],
                                    controller: presupuestoCtrl,
                                    validator: validatePresupuesto,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text("MENSAJE (OPCIONAL)",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                                  SizedBox(height: 5.0,),
                                  TextFormField(
                                    decoration: const InputDecoration(
//                                    labelText: "Mensaje (opcional)",
                                      border: OutlineInputBorder(),
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType:TextInputType.text ,
                                    controller: mensajeCtrl,
                                    minLines: 3,
                                    maxLines: 10,
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                          Container(
                            child:
                            RaisedButton(
                              color: Color.fromRGBO(255, 193, 7, 1),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.send,color: Colors.white,),
                                  Text(" Enviar propuesta",style: TextStyle(fontSize: 16,color: Colors.white),)
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              onPressed: ()async{
                                if (keyForm.currentState.validate()) {
                                  print("id user postulante: ${infoUser.id}");
                                  print("contra oferta presupuesto: ${presupuestoCtrl.text}");
                                  print("mensaje: ${mensajeCtrl.text}");
                                  print("estado postulacion: en revición");
//                      keyForm.currentState.reset();
                                  await _crud.addPropuestaPostulante(
                                      widget.publicacionTrabajoAlgolia.idUserPublicador,
                                      widget.publicacionTrabajoAlgolia.id,
                                      PropuestaPostulante(
                                        contraOfertaPresupuesto: int.parse(presupuestoCtrl.text.replaceAll(",", "")),
                                        estadoPostulacion: "0",
                                        idUserPostulante: infoUser.id,
                                        mensajeOpcional: mensajeCtrl.text,
                                        fechaCreacion: Timestamp.now(),
                                        idUserPublicante: widget.publicacionTrabajoAlgolia.idUserPublicador,
                                        idPublicacionTrabajoUserPublicante: widget.publicacionTrabajoAlgolia.id,
                                        categoriaPublicacionTrabajo: widget.publicacionTrabajoAlgolia.nombreCategoria,
                                        subCategoriaPublicacionTrabajo: widget.publicacionTrabajoAlgolia.nombreSubcategoria,
                                        tituloPublicacionTrabajo: widget.publicacionTrabajoAlgolia.titulo,
                                        calificacionAPostulanteGanador: 0, // 0 => no tiene calificacion
                                        calificacionAEmpleador: 0
                                      ),
                                      infoUser.id
                                  ).then((a){print("show");
                                  Scaffold.of(_).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 3000),
                                        elevation: 6.0,
                                        behavior: SnackBarBehavior.floating,
                                        content: Row(
                                          children: <Widget>[
                                            Icon(Icons.check),
                                            SizedBox(width: 20.0,),
                                            Expanded(child: Text("Se envio correctamente su propuesta."),)
                                          ],
                                        ),
                                      )
                                  );
                                  });
                                  await Future.delayed(Duration(seconds: 3));
                                  Navigator.of(context).pop();
                                }
                                else{
                                  print("El formulario tiene errores");
                                }
                              },
                              padding: EdgeInsets.all(10),
                            ),
                            padding: EdgeInsets.all(10.0),
                          )
//                        Center(
//                          child: Container(
//                            child: RaisedButton.icon(
//                              onPressed: (){},
//                              icon: Icon(Icons.send,color: Colors.white,),
//                              label:Text("Enviar propuesta",style: TextStyle(color: Colors.white),),
//                              color: Color.fromRGBO(255, 193, 7, 1),
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(20.0),
//                              ),
//                            ),
//                          )
//                        ),
                        ],

                      ),
                    );
                }
              }
            },
          ),
        )
    );
  }

  String validatePresupuesto(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Este campo es requerido.";
    }
    return null;
  }


}