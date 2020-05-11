import 'package:app/ui/views/curriculum_page.dart';
import 'package:app/ui/views/mis_publicaciones_page.dart';
import 'package:app/ui/views/search_publications_by_categories_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';




class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

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

    final crudProvider=Provider.of<crudModel>(context);
    final infoUser=Provider.of<LoginState>(context).infoUser();
    final infoUserFirebase=Provider.of<LoginState>(context).getUserFirebase();
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
//        backgroundImage: NetworkImage(infoUser.urlImagePerfil),
//        radius: 30,
//        backgroundColor: Colors.transparent,

        ClipOval(
          child:FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: infoUser.urlImagePerfil,height: 65,width: 65,fit: BoxFit.cover,)
//          Image.network(infoUser.urlImagePerfil),
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
//            Navigator.pushNamed(context, '/curriculumPage');
          },
        ),
        ListTile(
          leading: Icon(Icons.search),
          title: Text('Buscar empleos'),
          onTap: () => Navigator.of(context).push(_NewPage(2)),
        ),
        ListTile(
          leading: Icon(Icons.list),
          title: Text('Mis postulaciones'),
          onTap: () {}
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Bandeja de entrada'),
          onTap: () => Navigator.of(context).push(_NewPage(2)),
        ),
        ListTile(
          leading: Icon(Icons.note_add),
          title: Text('Mis Publicaciones'),
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
          centerTitle: true,
        ),
        body:buildCategorias(),
        drawer: Drawer(
          child: drawerItems,
        ));
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


// <Null> means this route returns nothing.
class _NewPage extends MaterialPageRoute<Null> {
  _NewPage(int id)
      : super(builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page $id'),
        elevation: 1.0,
      ),
      body:
      Center(
        child: Text('Page $id'),
      ),
    );
  });
}

//List<User> users;
//Container(
//child: StreamBuilder(
//stream: userProvider.fetchUsersAsStream(),
//builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//if (snapshot.hasData) {
//users = snapshot.data.documents
//    .map((doc) => User.fromMap(doc.data, doc.documentID))
//    .toList();
//return ListView.builder(
//itemCount: users.length,
//itemBuilder: (buildContext, index) =>
//_UserCard(userDetails: users[index]),
//);
//} else {
//return Text('fetching');
//}
//}
//),
//),
//
//Widget _UserCard({User userDetails}){
//  return Card(
//    child: Column(
//      children: <Widget>[
//        Text(userDetails.nombreCompleto),
//        Text(userDetails.id)
//      ],
//    ),
//  );
//}