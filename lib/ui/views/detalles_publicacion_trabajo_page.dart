import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/editar_publicacion_trabajo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetallesPublicacionTrabajoPage extends StatefulWidget {
  final String idPublicacionTrabajo;
  DetallesPublicacionTrabajoPage({Key key,this.idPublicacionTrabajo}) : super(key: key);

  @override
  _DetallesPublicacionTrabajoPageState createState() {
    return _DetallesPublicacionTrabajoPageState();
  }
}

class _DetallesPublicacionTrabajoPageState extends State<DetallesPublicacionTrabajoPage> {
  var _formatPublicacion = DateFormat.yMMMd('es').add_jm();
  var _formatLimite = DateFormat.yMMMd('es');
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
    final User infoUser=Provider.of<LoginState>(context).infoUser();
    final _crud= Provider.of<crudModel>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Detalles Publicación'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                showDialog<String>(
                  context:context,
                  builder: (BuildContext context)=>AlertDialog(
                    content: Text("¿Esta seguro que desea eliminar esta publicación?"),
                    actions: <Widget>[
                      FlatButton(
                        child: new Text("CANCELAR"),
                        onPressed: (){
                          Navigator.pop(context,'CANCELAR');
                        },
                      ),
                      FlatButton(
                        child: new Text("ELIMINAR"),
                        onPressed: ()  {
                          _crud.deletePublicacionUser(infoUser.id, widget.idPublicacionTrabajo);
                          Navigator.pop(context,'ELIMINAR');
                        },
                      )
                    ],
                  ),
                ).then((returnVal){
                  if(returnVal!= null){
                    if(returnVal=="ELIMINAR"){
                      Navigator.pop(context);
                    }
                  }
                });
              }
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(189, 189, 189, 0.1),
        child: FutureBuilder(
          future: _crud.getPublicacionTrabajoById(infoUser.id, widget.idPublicacionTrabajo),
          builder: ( _ ,  publicacioneSnap ){
            if(publicacioneSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(publicacioneSnap.data==null){
                return
                  Center(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Icon(Icons.error,size: 120.0,color: Color.fromRGBO(197, 202, 232, 1.0),),
                        SizedBox(height: 10,),
                        Center(
                          child: Text("La publicación no existe.",style: TextStyle(color: Colors.black38),),
                        ),
                      ],
                    ),
                  );
              }
              else{
                PublicacionTrabajoUser _publicacionTrabajo=publicacioneSnap.data;
                return 
                  ListView(
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          title: Text("Categoria: "+_publicacionTrabajo.nombreCategoria),
                          subtitle: Text("Que necesita: "+_publicacionTrabajo.nombreSubcategoria),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text("Publicado: "+_formatPublicacion.format(_publicacionTrabajo.fechaCreacion.toDate()),),
                              Text("Fecha Limite: "+ _formatPublicacion.format(_publicacionTrabajo.fechaLimite.toDate())),
                              Row(
                                children: <Widget>[
//                                  Icon(Icons.location_on),
//                                  SizedBox(width: 4,),
                                  Text("Lugar: "+_publicacionTrabajo.lugarTrabajo),
                                ],
                              ),
                              Text("Razón de pago: "+_publicacionTrabajo.razonDePago),
                              Text("Presupuesto: "+_publicacionTrabajo.presupuesto.toString()),
                              Text("Estado: "+_publicacionTrabajo.estadoPublicacionTrabajo),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text(_publicacionTrabajo.titulo,style: TextStyle(fontSize: 20.0),),
                              SizedBox(height: 8.0,),
                              Text(_publicacionTrabajo.descripcion),
                              Text(_publicacionTrabajo.habilidadesNecesarias),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),


                      SizedBox(height: 10,),

                          RaisedButton.icon(
                              color: Color.fromRGBO(255, 193, 7, 1),
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (_)=>EditarPublicacionTrabajoPage(publicacionTrabajo: _publicacionTrabajo,)));
                              },
                              icon: Icon(Icons.edit,color: Colors.white,),
                              label: Text("Editar",style: TextStyle(fontSize: 18,color: Colors.white),)),

                    ],
                    padding: EdgeInsets.all(10.0),
                  );
              }
            }
          },
        ),
      ),

    );
  }
}