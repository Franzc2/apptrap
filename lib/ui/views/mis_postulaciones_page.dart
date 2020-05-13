import 'package:app/core/models/propuestaPostulanteModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MisPostulacionesPage extends StatefulWidget {
  MisPostulacionesPage({Key key}) : super(key: key);

  @override
  _MisPostulacionesPageState createState() {
    return _MisPostulacionesPageState();
  }
}

class _MisPostulacionesPageState extends State<MisPostulacionesPage> {
  var format = DateFormat.yMd('es').add_jm();
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();

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
      key: this._scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Mis postulaciones'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: (){setState(() {});})
        ],
      ),
      body: Container(
        color: Color.fromRGBO(189, 189, 189, 0.1),
        child: FutureBuilder(
          future: _crud.getPostulaciones(infoUser.id),
          builder: (context, postulacionesSnap){
            if(postulacionesSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(postulacionesSnap.data.length==0){
                return Center(
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 40,),
                      Icon(Icons.style,size: 120.0,color: Color.fromRGBO(197, 202, 232, 1.0),),
                      SizedBox(height: 10,),
                      Center(
                        child: Text("Aún no publicaste trabajos.",style: TextStyle(color: Colors.black38),),
                      ),
                    ],
                  ),
                );
              }
              else{
                return ListView.builder(
                  itemCount: postulacionesSnap.data.length,
                  itemBuilder: (context, index){
                    PropuestaPostulante postulacion=postulacionesSnap.data[index];
                    return
                      Card(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        style: new TextStyle(fontSize: 15.0,color: Colors.black87),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: "Estado: ",
                                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)
                                          ),
                                          new TextSpan(text: postulacion.estadoPostulacion,style: TextStyle(fontSize: 15.0,color: Colors.green,fontWeight: FontWeight.bold))
                                        ]
                                    ),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0,right: 0,top: 2,bottom: 2),
                                  child: Text(postulacion.categoriaPublicacionTrabajo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0,color: Colors.black54)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0,bottom: 4.0),
                                  child: Text(postulacion.tituloPublicacionTrabajo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.indigo),),
                                ),
//                                Text(publicacionTrabajo.descripcion,maxLines: 3,overflow: TextOverflow.ellipsis,),
                                Padding(
                                    padding: EdgeInsets.only(top: 6.0,bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.watch_later,color: Colors.black54,size: 15,),
                                        SizedBox(width: 3.0,),
                                        Text(format.format(postulacion.fechaCreacion.toDate()),style: TextStyle(fontSize: 12),),
                                      ],
                                    )
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    style: new TextStyle(fontSize: 14.0,color: Colors.black87),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: "Contraoferta presupuesto: ",
                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)
                                      ),
                                      new TextSpan(text: postulacion.contraOfertaPresupuesto.toString()+" Bs.")
                                    ]
                                  ),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                          onTap: (){
//                            this._scaffoldKey.currentState.showBottomSheet((context)=>_buildBottomSheet(context, infoUser.id, publicacionTrabajo.id));
                          },
                        ),
                        elevation: 2,
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