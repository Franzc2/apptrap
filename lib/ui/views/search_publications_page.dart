import 'package:app/core/models/publicacionTrabajoAlgoliaModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:algolia/algolia.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'detalles_publicacion_trabajo_para_postulantes_page.dart';

class SearchCategoriesPage extends StatefulWidget {
  SearchCategoriesPage({Key key}) : super(key: key);

  @override
  _SearchCategoriesPageState createState() {
    return _SearchCategoriesPageState();
  }
}

class _SearchCategoriesPageState extends State<SearchCategoriesPage> {
  TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results;
  bool _searching = false;
  var format = DateFormat.yMd('es').add_jm();


  _search() async {

    setState(() {_searching = true;});

    Algolia algolia = Algolia.init(
      applicationId: 'CA8N1B30DY',
      apiKey: '484882b03fe047f42fb9ccbc998ad21d',
    );
    AlgoliaQuery query = algolia.instance.index('publicaciones').search(_searchText.text);
    query=query.setFilters("nivelImportancia>0");
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
            hintText: "Buscar trabajos...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white,fontSize: 16),
          ),
          controller: _searchText,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted:(String value){ _search();}

        ),
      ),
      body:
        Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _searching == true
                    ? Center(
                      child: Text("Cargando, espere por favor..."),
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
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget buildCategories(){
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
          child: Text("Categorías",style: TextStyle(fontSize: 22,),),
        ),
        ListTile(
          title: Text("Programación y tecnología"),
          leading: Icon(Icons.desktop_mac),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Diseño y multimedia"),
          leading: Icon(FontAwesomeIcons.pencilRuler),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Redacción y traducción"),
          leading: Icon(FontAwesomeIcons.penNib),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Marketing digital y ventas"),
          leading: Icon(FontAwesomeIcons.bullhorn),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Soporte administrativo"),
          leading: Icon(FontAwesomeIcons.headset),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Legal"),
          leading: Icon(FontAwesomeIcons.balanceScale),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Finanzas y negocios"),
          leading: Icon(Icons.assessment),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
        ListTile(
          title: Text("Ingeniería y arquitectura"),
          leading: Icon(FontAwesomeIcons.tools),
          trailing: Icon(Icons.navigate_next,color: Colors.green,),
          onTap: (){},
        ),
      ],
    );
  }
}