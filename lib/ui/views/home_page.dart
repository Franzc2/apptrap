
import 'dart:ui';

import 'package:algolia/algolia.dart';
import 'package:app/core/models/publicacionTrabajoAlgoliaModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/ui/views/curriculum_page.dart';
import 'package:app/ui/views/search_publications_by_categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:transparent_image/transparent_image.dart';

import 'detalles_publicacion_trabajo_para_postulantes_page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  List<AlgoliaObjectSnapshot> _results;
  bool _searching = false;
  var format = DateFormat.yMd('es').add_jm();


  _search() async {
    setState(() {_searching = true;});

    Algolia algolia = Algolia.init(
      applicationId: 'CA8N1B30DY',
      apiKey: '484882b03fe047f42fb9ccbc998ad21d',
    );
    AlgoliaQuery query = algolia.instance.index('publicaciones');
    query=query.setFilters("nivelImportancia>1");
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
    final infoUser=Provider.of<LoginState>(context).infoUser();
    final loginState=Provider.of<LoginState>(context);

    // TODO: implement build
    final drawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
          color: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      accountName: Text(infoUser.nombreCompleto),
      accountEmail: Text(infoUser.correoElectronico),
      currentAccountPicture:
      CircleAvatar(
        child:
        ClipOval(
          child:FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: infoUser.urlImagePerfil,height: 65,width: 65,fit: BoxFit.cover,)
        ),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          leading: Icon(Icons.person_outline,),
          title: Text('Información personal'),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonalInformationPage(user: infoUser,)));
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Mi currículum'),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CurriculumPage(user: infoUser,)));
          },
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text('Buscar empleos'),
            onTap: () {Navigator.pushNamed(context, '/buscarEmpleosPage');}
        ),
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Mis postulaciones'),
          onTap: () {Navigator.pushNamed(context, '/misPostulaciones');}
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Bandeja de entrada'),
          onTap: ()=>Navigator.pushNamed(context, '/chatsUserPage')
        ),
        ListTile(
          leading: Icon(Icons.note_add),
          title: Text('Mis publicaciones'),
          onTap: () => Navigator.pushNamed(context, '/misPublicaciones'),
        ),
        ListTile(
          leading: Icon(FontAwesomeIcons.signOutAlt),
          title: Text('Salir'),
          onTap: (){
            loginState.logout();
          }
        ),
      ],
    );
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor:Color.fromRGBO(63, 81, 181, 1.0),
          title:
          Container(
            width: 250,
            height:80,
            child: FlatButton(
              child:Row(
                children: <Widget>[
                  Text("Buscar trabajos... ",style: TextStyle(color: Colors.white,fontSize: 17.5),),
                  Icon(Icons.search,color: Colors.white,),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/searchCategories');
              },
            ),
          ),
          actions: <Widget>[
            IconButton
              (icon: Icon(Icons.refresh),
                onPressed: (){setState(() {
            _search();
            });},

            )
          ],
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Card(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.asset("assets/logos/logoMiEmpleoBlanco01.png",width: 70.0,fit: BoxFit.cover,),
                        padding: EdgeInsets.only(left: 20,right: 15,top: 0,bottom: .0),
                      ),
                      Expanded(
                        child: Container(
                          child: Text("Encuentra un nuevo trabajo, únete al equipo",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w600,color:Colors.white),),
                          padding: EdgeInsets.only(right: 25.0),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),

                  height: 90.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:AssetImage("assets/images/fondo01.jpg"),
                          fit:BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken)
                      )
                  ),
                ),
                clipBehavior: Clip.antiAlias,
              ),

              Container(
                child: Text("Publicaciones destacadas",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600,color: Colors.black87),),
                padding: EdgeInsets.only(right: 15,left: 15,bottom: 5,top: 12),
              ),
              //Divider(height: 1.0,),
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
                :
                GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _results.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
                  itemBuilder: (BuildContext ctx, int index){
                    AlgoliaObjectSnapshot snap=_results[index];
                    PublicacionTrabajoAlgolia publicacion=PublicacionTrabajoAlgolia.fromJson(snap.data, snap.objectID);
                    return cardVistaPreviaConImagen(publicacion);
                  }
                )
//                    Row(
//                      children:_results.map((algoliaPublicacion)=>cardVistaPreviaConImagen(algoliaPublicacion)).toList(),
//                    )

 //               ListView.builder(
 //                 itemCount: _results.length,
 //                 itemBuilder: (BuildContext ctx, int index) {
 //                   AlgoliaObjectSnapshot snap = _results[index];
 //                   PublicacionTrabajoAlgolia publicacion=PublicacionTrabajoAlgolia.fromJson(snap.data,snap.objectID);
 //                   return cardVistaPreviaConImagen(publicacion);
 //                 },
 //               ),
              ),

            ],
          ),
        ),
        drawer: Drawer(
          child: drawerItems,
        ));
  }

  Widget cardVistaPreviaConImagen(PublicacionTrabajoAlgolia publicacion){
    return
    Container(
          child: Card(
            child:
                InkWell(
                  child:
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: Image.network(publicacion.urlImagePublicacion,fit: BoxFit.cover,)
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child:
                        Container(
                          child: Center(
                            child: Text(publicacion.nombreCategoria,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,maxLines: 2,),
                          ),
                          height: 40,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> DetallesPublicacionTrabajoParaPostulantesPage(publicacionTrabajoAlgolia:publicacion,)));
                  },
                ),
            clipBehavior: Clip.antiAlias,

          ),

//          height: 150, width: 150,
        );
  }

  Widget buildCategorias(){
    return ListView(
      padding: EdgeInsets.only(right: 8.0,left: 8.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20,bottom: 10,left: 10,right: 10),
          child: Text("Categorías",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        ),
        Divider(height: 2.0,),
        ListTitleCategoria("Programación y tecnología", Icon(Icons.desktop_mac,color: Colors.blueAccent,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Diseño y multimedia", Icon(FontAwesomeIcons.pencilRuler,color: Colors.blue,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Redacción y traducción", Icon(FontAwesomeIcons.penNib,color: Colors.green,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Marketing digital y ventas", Icon(FontAwesomeIcons.bullhorn,color: Colors.amber)),
        Divider(height: 2.0,),
        ListTitleCategoria("Soporte administrativo", Icon(FontAwesomeIcons.headset,color: Colors.orange,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Legal", Icon(FontAwesomeIcons.balanceScale,color: Colors.red,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Finanzas y negocios", Icon(Icons.assessment,color: Colors.indigoAccent,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Ingeniería y arquitectura", Icon(FontAwesomeIcons.tools,color: Colors.purple,)),
        Divider(height: 2.0,),
        ListTitleCategoria("Trabajos manuales", Icon(FontAwesomeIcons.suitcase,color: Colors.cyan,)),
        Divider(height: 2.0,),
      ],
    );
  }

  Widget ListTitleCategoria(String nombreCategoria, Icon icon){
    return ListTile(
      title: Text(nombreCategoria),
      leading: icon,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPublicationsByCategoriesPage(nombreCategoria: nombreCategoria,)));
      },
    );
  }

}