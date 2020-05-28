import 'package:app/core/models/categoriaPublicacionModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/info_para_destacar_publicacion_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'info_para resaltar2.dart';



class AgregarPublicacionTrabajoPage extends StatefulWidget {
  final User user;
  AgregarPublicacionTrabajoPage({Key key, this.user}) : super(key: key);

  @override
  _AgregarPublicacionTrabajoPageState createState() {
    return _AgregarPublicacionTrabajoPageState();
  }
}

class _AgregarPublicacionTrabajoPageState extends State<AgregarPublicacionTrabajoPage> {



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
    return Scaffold(
      appBar: AppBar(
        title: Text("Publicar Trabajo"),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
                child: Text("Categorías",style: TextStyle(fontSize: 22,),),
              ),
              listTitleCategoria("Programación y tecnología", Icon(Icons.desktop_mac)),
              listTitleCategoria("Diseño y multimedia", Icon(FontAwesomeIcons.pencilRuler)),
              listTitleCategoria("Redacción y traducción", Icon(FontAwesomeIcons.penNib)),
              listTitleCategoria("Marketing digital y ventas", Icon(FontAwesomeIcons.bullhorn)),
              listTitleCategoria("Soporte administrativo", Icon(FontAwesomeIcons.headset)),
              listTitleCategoria("Legal", Icon(FontAwesomeIcons.balanceScale)),
              listTitleCategoria("Finanzas y negocios",Icon(Icons.assessment),),
              listTitleCategoria("Ingeniería y arquitectura", Icon(FontAwesomeIcons.tools)),
              listTitleCategoria("Trabajos universitarios", Icon(FontAwesomeIcons.book)),
              listTitleCategoria("Trabajos manuales", Icon(FontAwesomeIcons.tools))
            ],
          )
      ),
    );
  }
  Widget listTitleCategoria(String nombreCategoria, Icon icon,){
    return ListTile(
      title: Text(nombreCategoria),
      leading: icon,
      trailing: Icon(Icons.navigate_next,color: Colors.green,),
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> FormPublicarTrabajo(nombrecategoria: nombreCategoria,)));
      },
    );
  }
}


//-----------------------------------------------------------------------------------------------------------------------------------------------

class FormPublicarTrabajo extends StatefulWidget {
  final String nombrecategoria;
  FormPublicarTrabajo({Key key,this.nombrecategoria}) : super(key: key);

  @override
  _FormPublicarTrabajoState createState() {
    return _FormPublicarTrabajoState();
  }
}

class _FormPublicarTrabajoState extends State<FormPublicarTrabajo> {

  bool _loading=false;
  List<Categoria> _categorias=[];
  crudModel _crudCategorias=new crudModel();
  List<String> _subcategorias=[];
  List<DropdownMenuItem<String>> _dropDownMenuSubcategorias;
  String _btnSelectSubCategoria;
  List<String> urlsImagesParaDestacarPublicacion=[];

  static const menuRazonDePago=<String>[
    'Por trabajo finalizado',
    'Por horas de trabajo'
  ];

  static const menuModalidadDeTrabajo=<String>[
    'Presencial',
    'Semipresencial',
    'Teletrabajo'
  ];

  final List<DropdownMenuItem<String>> _dropDownMenuRazonDePago=menuRazonDePago
      .map(
          (String value)=>DropdownMenuItem<String>(
            value: value,
            child: Text(value),
      )).toList();

  final List<DropdownMenuItem<String>> _dropDownModalidadDeTrabajo=menuModalidadDeTrabajo
      .map(
          (String value)=>DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      )).toList();

  String _btnSelectRazonDePago;
  String _btnSelectModalidadDeTrabajo;


  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController tituloCtrl= new TextEditingController();
  TextEditingController descripcionCtrl= new TextEditingController();
  TextEditingController habilidadesNecesariasCtrl= new TextEditingController();
  TextEditingController lugarTrabajoCtrl= new TextEditingController();
  TextEditingController presupuestoCtrl= new TextEditingController();
  TextEditingController fechaLimiteCtrl= new TextEditingController();

  final formatFechaTextField= new DateFormat('dd-MM-yyyy');
  final formatFechaForFire= new DateFormat('yyyy-MM-dd');
  String fechaLimiteFire="";
  Widget dateLimitePublicacion(){
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (DateTime newdate){
        print(newdate);
        fechaLimiteCtrl.text=formatFechaTextField.format(newdate);
        fechaLimiteFire=formatFechaForFire.format(newdate).toString();
      },
      minimumDate: DateTime.now(),
      maximumYear: DateTime.now().year+1,
    );
  }


  cargarSubCategorias()async{
    _loading=true;
    _categorias=await _crudCategorias.getCategorias();
    _categorias.forEach((categoria){
      if(categoria.nombreCategoria==widget.nombrecategoria){
        _subcategorias=categoria.subCategorias;
        setState(() {
          _dropDownMenuSubcategorias= _subcategorias
              .map(
                  (String value)=>DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
              )).toList();
        });
      }

    });
    if(_dropDownMenuSubcategorias==null){
      setState(() {
        _dropDownMenuSubcategorias=[];
      });
    }
    _loading=false;
  }


  @override
  void initState() {
    super.initState();
    cargarSubCategorias();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final crudProvider=Provider.of<crudModel>(context);
    final User infoUser=Provider.of<LoginState>(context).infoUser();

    // TODO: implement build
    if(_loading==true && _dropDownMenuSubcategorias==null){
      return Scaffold(
        appBar: AppBar(
          title: Text("Publicar Trabajo"),
          backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        ),
        body: new Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{
      return Scaffold(
          appBar: AppBar(
            title: Text("Publicar Trabajo"),
            backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),

          ),
          body:Form(            key: keyForm,

            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child:Text(widget.nombrecategoria, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText:"Que necesita",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
                  ),
                  value: _btnSelectSubCategoria,
                  onChanged: (String newValue){
                    setState(() {
                      _btnSelectSubCategoria=newValue;
                    });
                  },
                  items: this._dropDownMenuSubcategorias,
                validator: validateQueNecesita,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Título",
                      border: OutlineInputBorder()
                  ),
                  keyboardType:TextInputType.text ,
                  textCapitalization: TextCapitalization.sentences,
                  controller: tituloCtrl,
                  validator: validateTitulo,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Descripción",
                      border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType:TextInputType.text ,
                  controller: descripcionCtrl,
                  validator: validateDescripcion,
                  minLines: 3,
                  maxLines: 10,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Habilidaes necesarias",
                      border: OutlineInputBorder()
                  ),
                  keyboardType:TextInputType.text ,
                  textCapitalization: TextCapitalization.sentences,
                  controller: habilidadesNecesariasCtrl,
                  validator: validateHabilidades,
                ),
//                SizedBox(height: 15,),
//                TextFormField(
//                  decoration: const InputDecoration(
//                      labelText: "Lugar de Trabajo",
//                      border: OutlineInputBorder()
//                  ),
//                  keyboardType:TextInputType.text ,
//                  textCapitalization: TextCapitalization.sentences,
//                  controller: lugarTrabajoCtrl,
//                  validator: validateLugarTrabajo,
//                ),
                SizedBox(height: 15,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText:"Modalidad de trabajo",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
                  ),
                  value: _btnSelectModalidadDeTrabajo,
                  onChanged: (String newValue){
                    setState(() {
                      _btnSelectModalidadDeTrabajo=newValue;
                    });
                  },
                  items: this._dropDownModalidadDeTrabajo,
                  validator: validateQueNecesita,
                ),
                SizedBox(height: 15,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText:"Razon de pago",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
                  ),
                  value: _btnSelectRazonDePago,
                  onChanged: (String newValue){
                    setState(() {
                      _btnSelectRazonDePago=newValue;
                    });
                  },
                  items: this._dropDownMenuRazonDePago,
                  validator: validateQueNecesita,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Presupuesto",
                      border: OutlineInputBorder(),
                    suffixText: 'Bs.'
                  ),
                  keyboardType:TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter()
                  ],
                  controller: presupuestoCtrl,
                  validator: validatePresupuesto,
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Fecha limite para postulaciones",
//                      filled: true,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.date_range)
                  ),
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext build){
                          return Container(
                            height: MediaQuery.of(context).copyWith().size.height /3 ,
                            child: dateLimitePublicacion(),
                          );
                        }
                    );
                  },
                  readOnly: true,
                  controller: fechaLimiteCtrl,
                  validator: validateFechaLimite,
                ),
                SizedBox(height: 15,),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Opcional",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:Colors.indigoAccent,
                  ),),
                ),
                Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text("Quieres que tu publicación sea mas visible?"),
//                          OutlineButton.icon(
//                              onPressed: (){
//                                Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoParaDestacarPublicacionPage()));
//                              },
//                              icon: Icon(Icons.star_border),
//                              label: Text("Destacar publicación.")),
                          OutlineButton.icon(
                              onPressed: () async{
                                urlsImagesParaDestacarPublicacion = await Navigator.push(context, MaterialPageRoute(builder: (context)=>InfoParaDestacarPublicacionPage1()));
                                print(urlsImagesParaDestacarPublicacion);
                              },
                              icon: urlsImagesParaDestacarPublicacion.length==0?Icon(Icons.star_border):Icon(Icons.star,color: Colors.amber,),
                              label: urlsImagesParaDestacarPublicacion.length==0?Text("Destacar publicación"):Text("Publicación destacada!"))
                        ],
                      ),
                    ),
                    elevation: 2.0,
                  ),

                ),
                Divider(),
                SizedBox(height: 15,),
                Container(
                  child:
                  RaisedButton(
                    color: Color.fromRGBO(63, 81, 181, 1),
                    child: Text("Publicar",style: TextStyle(fontSize: 18,color: Colors.white),),
                    onPressed: ()async{
                      String url1="";
                      String url2="";
                      if(urlsImagesParaDestacarPublicacion.length>0){
                        url1=urlsImagesParaDestacarPublicacion[0];
                        url2=urlsImagesParaDestacarPublicacion[1];
                      }

                      if (keyForm.currentState.validate()) {
                        print("categoria ${widget.nombrecategoria}");
                        print("que necesita ${_btnSelectSubCategoria}");
                        print("titulo ${tituloCtrl.text}");
                        print("descripcion ${descripcionCtrl.text}");
                        print("razon de pago ${_btnSelectRazonDePago}");
                        print("presupuesto ${presupuestoCtrl.text}");
                        print("fecha limite ${fechaLimiteCtrl.text}");
                        print("lugar de trabajo ${lugarTrabajoCtrl.text}");
//                      keyForm.currentState.reset();

                        await crudProvider.addPublicacionUser(
                            infoUser.id,
                            PublicacionTrabajoUser(
                              nombreCategoria: widget.nombrecategoria,
                              nombreSubcategoria: _btnSelectSubCategoria,
                              titulo: tituloCtrl.text,
                              descripcion: descripcionCtrl.text,
                              habilidadesNecesarias: habilidadesNecesariasCtrl.text,
                              razonDePago: _btnSelectRazonDePago,
                              presupuesto: int.parse(presupuestoCtrl.text.replaceAll(",", "")),
                              fechaLimite: Timestamp.fromDate(DateTime.parse(fechaLimiteFire)),
                              fechaCreacion: Timestamp.fromDate(DateTime.now()),
                              fechaCreacionAlgolia: Timestamp.now().seconds,
                              nivelImportancia: 0,
                              estadoPublicacionTrabajo: "Evaluando propuestas",
//                              lugarTrabajo: lugarTrabajoCtrl.text
                              modalidadDeTrabajo: _btnSelectModalidadDeTrabajo,
                              urlImagePublicacion: url1,
                              urlImageComprobantePago: url2
                            ),
                          infoUser
                        );
                        Navigator.popUntil(context, ModalRoute.withName('/misPublicaciones'));
                      }
                      else{
                        print("El formulario tiene errores");
                      }
                    },
                    padding: EdgeInsets.all(10),
                  ),
                )


              ],
              padding: EdgeInsets.only(
                  top: 10.0,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20
              ),
            ),
          )
      );


    }
  }

  String validateQueNecesita(String value) {
    if (value==null) {
      return "Seleccione una opción.";
    }
    return null;
  }

  String validateTitulo(String value) {
    if (value==null) {
      return "Este campo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateDescripcion(String value) {
    if (value==null) {
      return "Este campo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }

  String validateHabilidades(String value) {
    if (value==null) {
      return "Este campo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateLugarTrabajo(String value) {
    if (value==null) {
      return "Este campo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateRazonPago(String value) {
    if (value==null) {
      return "Seleccione una opción.";
    }
    return null;
  }

  String validatePresupuesto(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Este campo es requerido.";
    }
    return null;
  }

  String validateFechaLimite(String value) {
    if (value.length == 0) {
      return "La fecha es requerida.";
    }
    return null;
  }








}




//Container(
//child: new ListView(
//children: <Widget>[
//Container(
//child:Text(widget.nombrecategoria, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//padding: EdgeInsets.all(10),
//),
//SizedBox(height: 15,),
//Form(
//child: ListView(
//children: <Widget>[
//DropdownButtonFormField<String>(
//decoration: InputDecoration(
//labelText:"Que necesita",
//border: OutlineInputBorder(),
//contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
//),
//value: _btnSelectNivelEstudios,
//onChanged: (String newValue){
//setState(() {
//_btnSelectNivelEstudios=newValue;
//});
//},
//items: this._dropDownMenuNivelEstudios,
////                validator: validateNivelEstudios,
//),
//],
//)
//)
//
//],
//),
//margin: EdgeInsets.all(13),
//),
