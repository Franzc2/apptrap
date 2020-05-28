import 'package:app/ui/views/search_publications_by_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class BuscarEmpleosPage extends StatefulWidget {
  BuscarEmpleosPage({Key key}) : super(key: key);

  @override
  _BuscarEmpleosPageState createState() {
    return _BuscarEmpleosPageState();
  }
}

class _BuscarEmpleosPageState extends State<BuscarEmpleosPage> {
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
    // TODO: implement build
    return       Scaffold(
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