import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/src/functions/estados.dart';
import 'package:app/ui/views/detalles_postulacion_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostulantesGanadoresPublicacionPage extends StatefulWidget {
  final PublicacionTrabajoUser publicacionTrabajoUser;
  PostulantesGanadoresPublicacionPage({Key key, this.publicacionTrabajoUser}) : super(key: key);

  @override
  _PostulantesGanadoresPublicacionPageState createState() {
    return _PostulantesGanadoresPublicacionPageState();
  }
}

class _PostulantesGanadoresPublicacionPageState extends State<PostulantesGanadoresPublicacionPage> {

  var formatFecha = DateFormat.yMd('es');
  var formatHora = DateFormat.jm();
  double _calificacion=10.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showDialogCalificar( PropuestaPostulante _propuestaPostulante, User _userPostulante) async {

    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedCalificacion = await showDialog<double>(
      context: context,
      builder: (context) => CalificacionDialog(initialCalificacion: _calificacion, propuestaPostulante: _propuestaPostulante, userPostulante: _userPostulante ),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedCalificacion != null) {
      setState(() {
        _calificacion = selectedCalificacion;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    var crud=Provider.of<crudModel>(context);
    final infoUser=Provider.of<LoginState>(context).infoUser();

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Postulantes Ganadores'),
//        title: Text(widget.publicacionTrabajoUser.titulo),
      ),
      body: Container(
        child: FutureBuilder(
          future: crud.getPropuestasPostulantesGanadoresTrabajo(infoUser.id, widget.publicacionTrabajoUser.id),
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
                          child: Text("No se encontraron postulaciones aprobadas.",style: TextStyle(color: Colors.black38),),
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
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
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
                                    Divider(height: 5.0,),
                                    propuestaPostulante.calificacionAPostulanteGanador==0? Center(
                                      child: OutlineButton.icon(
                                        onPressed: (){
                                          _showDialogCalificar(propuestaPostulante, userPostulante);
                                        },
                                        icon: Icon(Icons.star_border),
                                        label: Text('Calificar'),
                                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      ),
                                    ):
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                                          child: Text('Calificacion a usuario: '+propuestaPostulante.calificacionAPostulanteGanador.toString()+'/10',style: TextStyle(fontWeight: FontWeight.w600),),
                                        )
                                  ],
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

class CalificacionDialog extends StatefulWidget {
  final double initialCalificacion;
  final PropuestaPostulante propuestaPostulante;
  final User userPostulante;
  CalificacionDialog({Key key, this.initialCalificacion, this.propuestaPostulante, this.userPostulante}) : super(key: key);

  @override
  _CalificacionDialogState createState() {
    return _CalificacionDialogState();
  }
}

class _CalificacionDialogState extends State<CalificacionDialog> {
  double _calificacion;
  int _labelCalificacion;
  @override
  void initState() {
    super.initState();
    _calificacion=widget.initialCalificacion;
    _labelCalificacion=_calificacion.toInt();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _crud=Provider.of<crudModel>(context);
    // TODO: implement build
    return AlertDialog(
      title: Text(widget.userPostulante.nombreCompleto),
      content: Container(
        width:300,height:300,
        child: ListView(
          children: <Widget>[
            Text('Calificación'),
            Slider(
              value: _calificacion,
              min: 1,
              max: 10,
              divisions: 9,
              label: "$_labelCalificacion",
              onChanged: (value) {
                setState(() {
                  _calificacion = value;
                  _labelCalificacion=_calificacion.toInt();
                });
              },
            ),
            Text(_labelCalificacion.toString()+"/10",textAlign: TextAlign.center,)
          ],
        ),
       // height: 90,
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            widget.propuestaPostulante.calificacionAPostulanteGanador=_labelCalificacion; //AQUI SE CAMBIA la calificacion del al postulante ganador
            _crud.editPropuestaPostulante(
                widget.propuestaPostulante.idUserPublicante,
                widget.propuestaPostulante.idPublicacionTrabajoUserPublicante,
                widget.propuestaPostulante.id,
                widget.propuestaPostulante,
                widget.propuestaPostulante.idUserPostulante
            );
            Navigator.pop(context, _calificacion);
          },
          color: Colors.blueAccent,
          child: Text('GUARDAR'),
        )
      ],

    );
  }
}