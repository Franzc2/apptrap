import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:app/core/models/publicacionTrabajoAlgoliaModel.dart';
import 'package:app/core/models/publicacionTrabajoModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/detalles_publicacion_trabajo_page.dart';
import 'package:app/ui/views/detalles_publicacion_trabajo_para_postulantes_page.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchPublicationsByCategoriesPage extends StatefulWidget {
  final String nombreCategoria;
  SearchPublicationsByCategoriesPage({Key key, this.nombreCategoria}) : super(key: key);

  @override
  _SearchPublicationsByCategoriesPageState createState() {
    return _SearchPublicationsByCategoriesPageState();
  }
}

class _SearchPublicationsByCategoriesPageState extends State<SearchPublicationsByCategoriesPage> {
  TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results;
  bool _searching = false;
  var format = DateFormat.yMd('es').add_jm();


  _search() async {
    setState(() {_searching = true;});
    Algolia algolia = Algolia.init(applicationId: 'CA8N1B30DY', apiKey: '484882b03fe047f42fb9ccbc998ad21d',);

    AlgoliaQuery query = algolia.instance.index('publicaciones').search(_searchText.text);
    query = query.setFacetFilter('nombreCategoria:'+widget.nombreCategoria);
    _results = (await query.getObjects()).hits;

    setState(() {_searching = false;});
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User infoUser=Provider.of<LoginState>(context).infoUser();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear,color: Colors.white,),
              onPressed: (){
                _searchText.clear();
                _search();
              },
            )
          ],
          title:
          TextField(
              decoration: InputDecoration(
                hintText: "Buscar...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white,fontSize: 16),
              ),
              controller: _searchText,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
//              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted:(String value){ _search();}
          ),
        ),
        body:
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0,top: 8.0,bottom: 8.0,right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.nombreCategoria,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              Expanded(
                child: _searching == true
                    ?
                Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 5.0,),
                      Text("Cargando, espere por favor..."),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                )
                    :_results==null
                    ?Center()
                    : _results.length == 0
                    ? Center(
                  child: Text("No se encontraron resultados."),
                )
                    : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    AlgoliaObjectSnapshot snap = _results[index];
                    PublicacionTrabajoAlgolia publicacion=PublicacionTrabajoAlgolia.fromJson(snap.data,snap.objectID);
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
                                  child: Text(snap.data["nombreCategoria"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0,color: Colors.black54)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0,bottom: 4.0),
//                                  child: Text(publicacionTrabajo.titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Color.fromRGBO(63, 81, 181, 0.8)),),
                                  child: Text(snap.data["titulo"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.indigo),),
                                ),
                                Text(snap.data["descripcion"],maxLines: 3,overflow: TextOverflow.ellipsis,),
                                Padding(
                                    padding: EdgeInsets.only(top: 6.0,bottom: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.watch_later,color: Colors.black54,size: 15,),
                                        SizedBox(width: 3.0,),
                                        Text(format.format(DateTime.fromMillisecondsSinceEpoch(snap.data["fechaCreacionAlgolia"]*1000)),style: TextStyle(fontSize: 12),),
                                      ],
                                    )
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                          onTap: (){
//                            if(infoUser.token==''){
//                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonalInformationPage(user: infoUser,)));
//                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (_)=> DetallesPublicacionTrabajoParaPostulantesPage(publicacionTrabajoAlgolia:publicacion,)));
//                            }
                          },
                        ),
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(10.0),
//                              side: BorderSide(color: Colors.black12)
//                        ),
                      );

//                      ListTile(
//                      leading: CircleAvatar(
//                        child: Text(
//                          (index + 1).toString(),
//                        ),
//                      ),
//                      title: Text(snap.data["titulo"]),
//                      subtitle: Text(snap.data["descripcion"]),
//                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}