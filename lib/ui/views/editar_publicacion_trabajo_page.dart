import 'package:app/core/models/categoriaPublicacionModel.dart';
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/curriculum_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';

class EditarPublicacionTrabajoPage extends StatefulWidget {
  final PublicacionTrabajoUser publicacionTrabajo;
  EditarPublicacionTrabajoPage({Key key,this.publicacionTrabajo}) : super(key: key);

  @override
  _EditarPublicacionTrabajoPageState createState() {
    return _EditarPublicacionTrabajoPageState();
  }
}

class _EditarPublicacionTrabajoPageState extends State<EditarPublicacionTrabajoPage> {

  bool _loading=false;
  List<Categoria> _categorias=[];
  crudModel _crudCategorias=new crudModel();
  List<String> _subcategorias=[];
  List<DropdownMenuItem<String>> _dropDownMenuSubcategorias;
  String _btnSelectSubCategoria;

  static const menuRazonDePago=<String>[
    'Por trabajo finalizado',
    'Por horas de trabajo'
  ];
  final List<DropdownMenuItem<String>> _dropDownMenuRazonDePago=menuRazonDePago
      .map(
          (String value)=>DropdownMenuItem<String>(
            value: value,
             child: Text(value),
      )).toList();
  String _btnSelectRazonDePago;

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
      if(categoria.nombreCategoria==widget.publicacionTrabajo.nombreCategoria){
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
    cargarDatos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  cargarDatos(){
    _btnSelectSubCategoria=widget.publicacionTrabajo.nombreSubcategoria;
    tituloCtrl.text=widget.publicacionTrabajo.titulo;
    descripcionCtrl.text=widget.publicacionTrabajo.descripcion;
    habilidadesNecesariasCtrl.text=widget.publicacionTrabajo.habilidadesNecesarias;
    lugarTrabajoCtrl.text=widget.publicacionTrabajo.lugarTrabajo;
    _btnSelectRazonDePago=widget.publicacionTrabajo.razonDePago;
    presupuestoCtrl.text=widget.publicacionTrabajo.presupuesto.toString();
    fechaLimiteCtrl.text=formatFechaTextField.format(widget.publicacionTrabajo.fechaLimite.toDate());
    fechaLimiteFire=formatFechaForFire.format(widget.publicacionTrabajo.fechaLimite.toDate());
  }


  @override
  Widget build(BuildContext context) {

    final crudProvider=Provider.of<crudModel>(context);
    final User infoUser=Provider.of<LoginState>(context).infoUser();

    // TODO: implement build
    if(_loading==true && _dropDownMenuSubcategorias==null){
      return Scaffold(
        appBar: AppBar(
          title: Text("Editar Trabajo"),
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
            title: Text("Editar Trabajo"),
            backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),

          ),
          body:Form(
            key: keyForm,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child:Text(widget.publicacionTrabajo.nombreCategoria, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                SizedBox(height: 15,),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Lugar de Trabajo",
                      border: OutlineInputBorder()
                  ),
                  keyboardType:TextInputType.text ,
                  textCapitalization: TextCapitalization.sentences,
                  controller: lugarTrabajoCtrl,
                  validator: validateLugarTrabajo,
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
                Container(
                  child:
                  RaisedButton(
                    color: Color.fromRGBO(63, 81, 181, 1),
                    child: Text("Guardar",style: TextStyle(fontSize: 18,color: Colors.white),),
                    onPressed: ()async{
                      if (keyForm.currentState.validate()) {
                        print("categoria ${widget.publicacionTrabajo.nombreCategoria}");
                        print("que necesita ${_btnSelectSubCategoria}");
                        print("titulo ${tituloCtrl.text}");
                        print("descripcion ${descripcionCtrl.text}");
                        print("razon de pago ${_btnSelectRazonDePago}");
                        print("presupuesto ${presupuestoCtrl.text}");
                        print("fecha limite ${fechaLimiteCtrl.text}");
                        print("lugar de trabajo ${lugarTrabajoCtrl.text}");
                        await crudProvider.editPublicacionUser(
                            infoUser.id,
                            widget.publicacionTrabajo.id,
                            PublicacionTrabajoUser(
                                nombreCategoria: widget.publicacionTrabajo.nombreCategoria,
                                nombreSubcategoria: _btnSelectSubCategoria,
                                titulo: tituloCtrl.text,
                                descripcion: descripcionCtrl.text,
                                habilidadesNecesarias: habilidadesNecesariasCtrl.text,
                                razonDePago: _btnSelectRazonDePago,
                                presupuesto: int.parse(presupuestoCtrl.text.replaceAll(",", "")),
                                fechaLimite: Timestamp.fromDate(DateTime.parse(fechaLimiteFire)),
                                fechaCreacion: widget.publicacionTrabajo.fechaCreacion,
                                nivelImportancia: 0,
                                estadoPublicacionTrabajo: "Evaluando propuestas",
                                lugarTrabajo: lugarTrabajoCtrl.text
                            )
                        );
//                        Navigator.popUntil(context, ModalRoute.withName('/misPublicaciones'));
                        Navigator.of(context).pop();
//                        Navigator.popUntil(context, MaterialPageRoute(builder: (context)=>CurriculumPage(user: infoUser,)),(Route<dynamic>route)=>false);
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