import 'dart:io';

import 'package:app/core/models/chatModel.dart';
import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/experiencia_profesional_page.dart';
import 'package:app/ui/views/formacion_postulante_page.dart';
import 'package:app/ui/views/informacion_personal_postulante_page.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:app/src/functions/estados.dart';

import 'chat_page.dart';

class DetallesPostulacionPage extends StatefulWidget {
  final PropuestaPostulante propuestaPostulante;
  DetallesPostulacionPage({Key key, this.propuestaPostulante}) : super(key: key);

  @override
  _DetallesPostulacionPageState createState() {
    return _DetallesPostulacionPageState();
  }
}

class _DetallesPostulacionPageState extends State<DetallesPostulacionPage> {
  var formatFecha = DateFormat.yMd('es');
  var formatFechaNacimiento = DateFormat.yMMMMd('es');
  var formatHora = DateFormat.jm();
  bool _cargandoChat=false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<File> createFileOfPdfUrl(String urlDoc) async {
    final url = urlDoc;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final User infoUser=Provider.of<LoginState>(context).infoUser();
    final _crud= Provider.of<crudModel>(context);

    void abrirPdf(String url, String namePDF)async{
      File fl= await createFileOfPdfUrl(url);
      String pathpdf=fl.path;
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>PDFScreen(pathpdf,namePDF))
      );
//      loginState.cargarDatosUser(infoUser.id);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Inf. postulante'),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),

      persistentFooterButtons: widget.propuestaPostulante.estadoPostulacion=="0"?<Widget>[
        FlatButton.icon(
          onPressed: (){
            showDialog<String>(
              context:context,
              builder: (BuildContext context)=>AlertDialog(
                content: Text("¿Esta seguro de rechazar esta propuesta?"),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("CANCELAR"),
                    onPressed: (){
                      Navigator.pop(context,'CANCELAR');
                    },
                  ),
                  RaisedButton(
                    child: new Text("RECHAZAR"),
                    onPressed: ()  {
                      widget.propuestaPostulante.estadoPostulacion="2"; //AQUI SE CAMBIA EL ESTADO DE DE LA POSTULACION
                      _crud.editPropuestaPostulante(
                          widget.propuestaPostulante.idUserPublicante,
                          widget.propuestaPostulante.idPublicacionTrabajoUserPublicante,
                          widget.propuestaPostulante.id,
                          widget.propuestaPostulante,
                          widget.propuestaPostulante.idUserPostulante
                      );
                      //_crud.editPropuestaPostulante(idDocUserCollection, idDocPublicacionTrabajo, idDocPropuestaPostulante, data, idUserPostulante)
                      Navigator.pop(context,'RECHAZAR');
                    },
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ).then((returnVal){
              if(returnVal!= null){
                if(returnVal=="RECHAZAR"){
                  Navigator.pop(context);
                }
              }
            });
          },
          icon: Icon(Icons.clear),
          label: Text("Rechazar"),
        ),
        RaisedButton.icon(
          onPressed: (){
            showDialog<String>(
              context:context,
              builder: (BuildContext context)=>AlertDialog(
                content: Text("¿Esta seguro de aprobar esta propuesta?"),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("CANCELAR"),
                    onPressed: (){
                      Navigator.pop(context,'CANCELAR');
                    },
                  ),
                  RaisedButton(
                    child: new Text("CONFIRMAR"),
                    onPressed: ()  {
                      //_crud.deletePublicacionUser(infoUser.id, widget.idPublicacionTrabajo);
                      widget.propuestaPostulante.estadoPostulacion="1";
                      _crud.editPropuestaPostulante(
                          widget.propuestaPostulante.idUserPublicante,
                          widget.propuestaPostulante.idPublicacionTrabajoUserPublicante,
                          widget.propuestaPostulante.id,
                          widget.propuestaPostulante,
                          widget.propuestaPostulante.idUserPostulante
                      );
                      //_crud.editPropuestaPostulante(idDocUserCollection, idDocPublicacionTrabajo, idDocPropuestaPostulante, data, idUserPostulante)
                      Navigator.pop(context,'CONFIRMAR');
                    },
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ).then((returnVal){
              if(returnVal!= null){
                if(returnVal=="CONFIRMAR"){
                  Navigator.pop(context);
                }
              }
            });
          },
          icon: Icon(Icons.done),
          label: Text("Aprobar"),
          color: Colors.blueAccent,
        ),
      ]:null,
      body: Container(
        child: FutureBuilder(
          future: _crud.getUserById(widget.propuestaPostulante.idUserPostulante),
          builder: (context, userPostulanteSnap ){
            if(userPostulanteSnap.connectionState==ConnectionState.waiting){
              return Container();
            }
            else{
              User userPostulante=userPostulanteSnap.data;
              return
                ListView(
                  children: <Widget>[
                    Center(
                      child: Text("Estado: "+ getEstadoPostulacion(widget.propuestaPostulante.estadoPostulacion.toString()),style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.indigo),),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: widget.propuestaPostulante.calificacionAPostulanteGanador!=0?
//                        RaisedButton.icon(
//                          onPressed: (){
//                            _showDialogCalificar(widget.propuestaPostulante);
//                          },
//                          icon: Icon(Icons.star_border,color: Colors.white,),
//                          label: Text("Calificar a Empleador",style: TextStyle(color: Colors.white),),
//                          color: Colors.blue,
//                        ):
                        Text("Calificacion a usuario: "+widget.propuestaPostulante.calificacionAPostulanteGanador .toString()+"/10", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),):null,
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(child: Image.network(userPostulante.urlImagePerfil),),
                            radius: 25.0,
                          ),
                          title: Text(userPostulante.nombreCompleto),
                          trailing:Column(
                            children: <Widget>[
                              Container(
                                  child: formatFecha.format(widget.propuestaPostulante.fechaCreacion.toDate())==formatFecha.format(DateTime.now())
                                      ?Text(formatHora.format(widget.propuestaPostulante.fechaCreacion.toDate()),style: TextStyle(fontSize: 12.0),)
                                      :Text(formatFecha.format(widget.propuestaPostulante.fechaCreacion.toDate()),style: TextStyle(fontSize: 12.0))
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onTap: (){
//                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetallesPostulacionPage(propuestaPostulante: propuestaPostulante,)));
                          },
                        ),
                      ),
                      elevation: 2.0,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.monetization_on,color: Colors.amber,),
                              title:RichText(
                                text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                    ),
                                    children:[
                                      TextSpan(text: 'Contraoferta: '),
                                      TextSpan(text: widget.propuestaPostulante.contraOfertaPresupuesto.toString()+'Bs.',style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                ),
                              ),
                            ),
                            Divider(height: 2.0,),
                            widget.propuestaPostulante.mensajeOpcional==""? Container()
                                :ListTile(
                              leading: Icon(Icons.mail,color: Colors.blueAccent,),
                              title: RichText(
                                text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                    ),
                                    children:<TextSpan> [
//                                      TextSpan(text: 'Mensaje: '),
                                      TextSpan(text: widget.propuestaPostulante.mensajeOpcional,style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                ),
                              ),
                            ),
                          ]
                        ),
                      ),
                      elevation: 2.0,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
//                          leading:  CircleAvatar(
//                            child: ClipOval(child: Image.network(widget.userPostulante.urlImagePerfil),),
//                            radius: 25.0,
//                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              infoPersonalItem("Ciudad residencia", userPostulante.ciudadRecidencia),
                              infoPersonalItem("Fecha nacimiento", formatFechaNacimiento.format(userPostulante.fechaNacimiento.toDate())),
                              infoPersonalItem("Telefono", userPostulante.telefonoCelular),
                              infoPersonalItem("Correo electronico", userPostulante.correoElectronico)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8.0),
                      child: Text('Curriculum', style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.indigo),),),
//                    OutlineButton.icon(
//                        onPressed: (){
//                          Navigator.push(context, MaterialPageRoute(builder: (context)=>InformacionPersonalPostulantePage(userPostulante: userPostulante,) ));
//                        },
//                        icon: Icon(Icons.assignment_ind),
//                        label: Text('Información personal')
//                    ),
                    OutlineButton.icon(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FormacionPostulantePage(userPostulante: userPostulante,) ));
                        },
                        icon: Icon(Icons.school),
                        label: Text('Formación')
                    ),
                    OutlineButton.icon(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExperienciaProfesionalPage(userPostulante: userPostulante,) ));
                        },
                        icon: Icon(Icons.work),
                        label: Text('Experiencia profesional')),
                    userPostulante.urlDocumentCurriculum=="" || userPostulante.urlDocumentCurriculum==null?Container():OutlineButton.icon(
                        onPressed: (){
                          abrirPdf(userPostulante.urlDocumentCurriculum, userPostulante.nameDocCurriculum);
                        },
                        icon: Icon(Icons.attach_file),
                        label: Text('Ver documento adjunto')
                    ),

                    FutureBuilder(
                        future: _crud.getUserById(widget.propuestaPostulante.idUserPostulante),
                        builder: (_ ,userSnap){
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
                                        child: Text("no se encontro al usuario.",style: TextStyle(color: Colors.black38),),
                                      ),
                                    ],
                                  ),
                                );
                            }
                            else{
                              User userPostulante=userSnap.data;
                              return
                                RaisedButton.icon(
                                    color: Colors.blueAccent,
                                    onPressed: ()async{
                                      if(_cargandoChat==true){
                                        print("esta cargando");
                                      }else{
                                        _cargandoChat=true;
                                        print(infoUser.id);
//                            print(userPublicador.id);
                                        print(widget.propuestaPostulante.idUserPublicante);
                                        Chat chat=await _crud.getChat(infoUser.id, widget.propuestaPostulante.idUserPostulante);
                                        _cargandoChat=false;
                                        if(chat==null){
                                          print("no existe un chat algo esta mal se supone que se tenia que registrar");
                                        }else{
                                          print("chat: "+chat.toString());
                                          _cargandoChat? null
                                              :infoUser.token==""?
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalInformationPage(user: infoUser,))):
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(otroUser: userPostulante,chat: chat,)));
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.message, color: Colors.white,),
                                    label: Text("Enviar mensaje",style: TextStyle(color: Colors.white),));
                            }

                          }
                        }
                    )

                    
                  ],
                  padding: EdgeInsets.only(right: 8.0,left: 8.0, top: 8.0, bottom: 30),
                  
                );
            }
          },
        ),
      ),
    );
  }
  Widget infoPersonalItem(String nombre, String detalle){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children: [
              TextSpan(text: nombre+': '),
              TextSpan(text: detalle,style: TextStyle(fontWeight: FontWeight.bold,)),
            ]
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  String namePDF="";
  PDFScreen(this.pathPDF,this.namePDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(namePDF),
          backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.share),
//              onPressed: () {},
//            ),
//          ],
        ),
        path: pathPDF);
  }
}