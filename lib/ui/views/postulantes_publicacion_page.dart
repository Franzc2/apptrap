import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/src/functions/estados.dart';
import 'package:app/ui/views/detalles_postulacion_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostulantesPublicacionPage extends StatefulWidget {
  final PublicacionTrabajoUser publicacionTrabajoUser;
  PostulantesPublicacionPage({Key key, this.publicacionTrabajoUser}) : super(key: key);

  @override
  _PostulantesPublicacionPageState createState() {
    return _PostulantesPublicacionPageState();
  }
}

class _PostulantesPublicacionPageState extends State<PostulantesPublicacionPage> {

  var formatFecha = DateFormat.yMd('es');
  var formatHora = DateFormat.jm();
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
    var crud=Provider.of<crudModel>(context);
    final infoUser=Provider.of<LoginState>(context).infoUser();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Postulantes'),
//        title: Text(widget.publicacionTrabajoUser.titulo),
      ),
      body: Container(
        child: FutureBuilder(
          future: crud.getPropuestasPostulantesTrabajo(infoUser.id, widget.publicacionTrabajoUser.id),
          builder: (_, propuestasPostulantesSnap){
            if(propuestasPostulantesSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(propuestasPostulantesSnap.data.length==0){
                return
                  Center(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Icon(Icons.style,size: 120.0,color: Color.fromRGBO(197, 202, 232, 1.0),),
                        SizedBox(height: 10,),
                        Center(
                          child: Text("Aún no hay postulaciones.",style: TextStyle(color: Colors.black38),),
                        ),
                      ],
                    ),
                  );
              }
              else{
                return ListView.builder(
                    itemCount: propuestasPostulantesSnap.data.length,
                    itemBuilder: (_, index){
                      PropuestaPostulante propuestaPostulante=propuestasPostulantesSnap.data[index];
                      return
                        FutureBuilder(
                          future: crud.getUserById(propuestaPostulante.idUserPostulante),
                          builder: (buildContext, userSnap){
                            if(userSnap.connectionState==ConnectionState.waiting){
                              return Container();
                            }
                            else{
                              User userPostulante=userSnap.data;
                              return
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: ClipOval(child: Image.network(userPostulante.urlImagePerfil),),
                                        radius: 25.0,
                                      ),
                                      title: Text(userPostulante.nombreCompleto),
                                      subtitle: Text( getEstadoPostulacion(propuestaPostulante.estadoPostulacion.toString()), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),),
//                                    subtitle: Text('Contraoferta: '+propuestaPostulante.contraOfertaPresupuesto.toString()+' Bs.'),
                                      trailing:Column(
                                        children: <Widget>[
//                                            Text(formatFecha.format(mensajes.first.fechaMensaje.toDate()),style: TextStyle(fontSize: 10.0),)
                                          Container(
                                              child: formatFecha.format(propuestaPostulante.fechaCreacion.toDate())==formatFecha.format(DateTime.now())
                                                  ?Text(formatHora.format(propuestaPostulante.fechaCreacion.toDate()),style: TextStyle(fontSize: 12.0),)
                                                  :Text(formatFecha.format(propuestaPostulante.fechaCreacion.toDate()),style: TextStyle(fontSize: 12.0))
                                          ),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                      onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DetallesPostulacionPage(propuestaPostulante: propuestaPostulante,)));
                                      },
                                    ),
                                  ),
                                  elevation: 3.0,
                                );
                            }
                          },
                        );
                  },
                );
              }

            }
          },
        ),
      ),
    );
  }
}