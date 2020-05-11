import 'dart:ui';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/detalles_publicacion_trabajo_page.dart';
import 'package:app/ui/views/editar_publicacion_trabajo_page.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/core/viewmodels/crudModel.dart';

import 'agregar_publicacion_trabajo_page.dart';

class MisPublicacionesPage extends StatefulWidget {
  MisPublicacionesPage({Key key}) : super(key: key);

  @override
  _MisPublicacionesPageState createState() {
    return _MisPublicacionesPageState();
  }
}

class _MisPublicacionesPageState extends State<MisPublicacionesPage> {

//  var format = DateFormat.yMMMMEEEEd('es');
  var format = DateFormat.yMd('es').add_jm();
//  yMd().add_jm()
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
        title: Text('Mis Publicaciones'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: (){setState(() {});})
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(infoUser.numCI==""){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalInformationPage(user: infoUser,)));
          }
          else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AgregarPublicacionTrabajoPage()));
          }
        },
        label: Text("Publicar"),
        icon: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Color.fromRGBO(255, 193, 7, 1),
      ),
      body:

      Container(
        color: Color.fromRGBO(189, 189, 189, 0.1),
        child: FutureBuilder(
          future: _crud.getPublicacionesUser(infoUser.id),
          builder: ( _ ,  publicacionesSnap ){
            if(publicacionesSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(publicacionesSnap.data.length==0){
                return
                  Center(
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
                  itemCount: publicacionesSnap.data.length,
                  itemBuilder: (_, index){
                    PublicacionTrabajoUser publicacionTrabajo=publicacionesSnap.data[index];
                    return
                      Card(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 0,right: 0,top: 2,bottom: 2),
                                  child: Text(publicacionTrabajo.nombreCategoria,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0,color: Colors.black54)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0,bottom: 4.0),
                                  child: Text(publicacionTrabajo.titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.indigo),),
                                ),
                                Text(publicacionTrabajo.descripcion,maxLines: 3,overflow: TextOverflow.ellipsis,),
                                Padding(
                                    padding: EdgeInsets.only(top: 6.0,bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.watch_later,color: Colors.black54,size: 15,),
                                        SizedBox(width: 3.0,),
                                        Text(format.format(publicacionTrabajo.fechaCreacion.toDate()),style: TextStyle(fontSize: 12),),
                                      ],
                                    )
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                          onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_)=>DetallesPublicacionTrabajoPage(idPublicacionTrabajo: publicacionTrabajo.id,)));

                          },
                        ),
                      );
                  },
                  padding:EdgeInsets.all(8),
                );
              }

            }
        },
        ),
      )
//      buildPublicaciones(context,publicacionesUser)
    );
  }



//este codigo es para prueba------------------------------------------------------------------------------------------

  Widget buildPublicaciones(BuildContext context, List<PublicacionTrabajoUser> publicacionesUser){
    print('numero de publicaciones' + publicacionesUser.length.toString());
    if(publicacionesUser.length==0){
      return  Container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20,),
            Center(
              child: Text("Aun no publicaste trabajos."),
            ),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: (){
//                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AgregarPublicacionTrabajoPage(user: widget.user,)));
                },
                child: Text("Añadir publicaciónn"),
              ),
            )

          ],
        ),
      );
    }else{
      return Column(
        children: publicacionesUser.map((publicacion)=> buildCardPublicacion(context,publicacion)).toList(),
        mainAxisSize: MainAxisSize.max,
//        verticalDirection: VerticalDirection.up,
      );
    }
  }


  Widget buildCardPublicacion(BuildContext context,PublicacionTrabajoUser publicacion){
    return Card(
      child: ListTile(
        title: Text(
          publicacion.titulo,
          ),
          subtitle: Text(publicacion.descripcion),
        onTap: (){
//          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditarFormacionPage(user: widget.user,formacion: formacion,)));
        },
      ),
    );
  }


}






