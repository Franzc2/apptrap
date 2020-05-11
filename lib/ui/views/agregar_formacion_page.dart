import 'package:app/core/models/formacionModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarFormacionPage extends StatefulWidget {
  final User user;
  AgregarFormacionPage({Key key,this.user}) : super(key: key);

  @override
  _AgregarFormacionPageState createState() {
    return _AgregarFormacionPageState();
  }
}

class _AgregarFormacionPageState extends State<AgregarFormacionPage> {

  final bool cargando=false;
  String fechaInicioFire="";
  String fechaFinFire="";

  final formatFechaTextField= new DateFormat('dd-MM-yyyy');
  final formatFechaForFire= new DateFormat('yyyy-MM-dd');

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController institucionCtrl= new TextEditingController();
  TextEditingController fechaInicioCtrl= new TextEditingController();
  TextEditingController fechaFinCtrl= new TextEditingController();

  DateTime Fecha_inicio;

  static const menuNivelEstudios=<String>[
    'Educación Básica Primaria',
    'Educación Básica Secundaria',
    'Bachillerato/Educación Media',
    'Educación Técnico/Profesional',
    'Universidad',
    'Postgrado'
  ];

  static const menuEstadoActual=<String>[
    'Actualmente',
    'Culminado',
    'Abandonado/Aplazado'
  ];

  String _btnSelectNivelEstudios;
  String _btnSelectEstadoActual;

  final List<DropdownMenuItem<String>> _dropDownMenuNivelEstudios=menuNivelEstudios
      .map(
          (String value)=>DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          )).toList();
  final List<DropdownMenuItem<String>> _dropDownMenuEstadoActual=menuEstadoActual
      .map(
          (String value)=>DropdownMenuItem<String>(
            value: value,
            child: Text(value),
      )).toList();


  @override
  void initState() {
    super.initState();
    Fecha_inicio=DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget dateInicio(){
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newdate){
        print(newdate);
        fechaInicioCtrl.text=formatFechaTextField.format(newdate);
        Fecha_inicio=newdate; //fecha para definir el minimo en el campo Fecha fin trabajo
        fechaInicioFire=formatFechaForFire.format(newdate).toString();
      },
      minimumYear: DateTime.now().year-100,
      maximumDate: DateTime.now(),
      maximumYear: DateTime.now().year,
    );
  }

  Widget dateFin(){
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newdate){
        print(newdate);
        fechaFinCtrl.text=formatFechaTextField.format(newdate);
        fechaFinFire=formatFechaForFire.format(newdate).toString();
      },
      maximumDate: DateTime.now(),
      minimumDate: Fecha_inicio,
    );
  }

  @override
  Widget build(BuildContext context) {
    var expProfProvider=Provider.of<crudModel>(context);
    final loginState=Provider.of<LoginState>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Formación'),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      body: Form(
        key: keyForm,
        child:
        ListView(
          padding: EdgeInsets.only(
              top: 20.0,
              right: 20.0,
              left: 20.0,
              bottom: 20
          ),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Institución",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business)
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType:TextInputType.text ,
              controller: institucionCtrl,
              validator: validateInstitucion,
              onChanged: (value){
                validateInstitucion(value);
              },
            ),
            SizedBox(height: 15,),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                labelText:"Nivel de Estudios",
                contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
              ),
              value: _btnSelectNivelEstudios,
              onChanged: (String newValue){
                setState(() {
                  _btnSelectNivelEstudios=newValue;
                });
              },
              items: this._dropDownMenuNivelEstudios,
              validator: validateNivelEstudios,
            ),
            SizedBox(height: 15,),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:"Estado actual de la formación",
                  contentPadding: EdgeInsets.only(top: 5,bottom: 5,right: 13,left: 13)
              ),
              value: _btnSelectEstadoActual,
              onChanged: (String newValue){
                setState(() {
                  _btnSelectEstadoActual=newValue;
                });
              },
              items: this._dropDownMenuEstadoActual,
              validator: validateEstadoActual,
            ),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                new Flexible(
                    child:TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Inicio",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range)
                      ),
                      onTap: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext build){
                              return Container(
                                height: MediaQuery.of(context).copyWith().size.height /3 ,
                                child: dateInicio(),
                              );
                            }
                        );
                      },
                      readOnly: true,
                      controller: fechaInicioCtrl,
                      validator: validateFechaInicio,
                    ),
                ),
                SizedBox(
                  width: 5,
                ),
                new Flexible(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Fin",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range)
                      ),
                      onTap: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext build){
                              return Container(
                                height: MediaQuery.of(context).copyWith().size.height /3 ,
                                child: dateFin(),
                              );
                            }
                        );
                      },
                      readOnly: true,
                      controller: fechaFinCtrl,
                      validator: validateFechaFin,
                    ),
                ),
              ],
            ),

            SizedBox(height: 15,),
            Container(
              child:
              RaisedButton(
                color: Color.fromRGBO(63, 81, 181, 1),
                child: Text("Guardar",style: TextStyle(fontSize: 18,color: Colors.white),),
                onPressed: ()async{
                  if (keyForm.currentState.validate()) {
                    print("institucion ${institucionCtrl.text}");
                    print("nivel studios ${_btnSelectNivelEstudios}");
                    print("estado actual ${_btnSelectEstadoActual}");
                    print("fecha inicio ${fechaInicioCtrl.text}");
                    print("fecha fin ${fechaFinCtrl.text}");
//                      keyForm.currentState.reset();
                    await expProfProvider.addFormacionUser(
                        widget.user.id,
                        Formacion(
                          institucion: institucionCtrl.text,
                          fechaInicio: Timestamp.fromDate(DateTime.parse(fechaInicioFire)),
                          fechaFin: Timestamp.fromDate(DateTime.parse(fechaFinFire)),
                          fechaCreacion: Timestamp.fromDate(DateTime.now()),
                          nivelEstudios: _btnSelectNivelEstudios,
                          estadoActualFormacion:_btnSelectEstadoActual,
                        )
                    );
                    await loginState.cargarFormacionUser(widget.user.id);
                    Navigator.pop(context);
                  }
                  else{
                    print("El formulario tiene errores");
                  }
                },
                padding: EdgeInsets.all(10),
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateInstitucion(String value) {
    if (value==null) {
      return "El nombre de la Institucion es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateNivelEstudios(String value) {
    if (value==null) {
      return "Seleccine una opción.";
    }
    return null;
  }
  String validateEstadoActual(String value) {
    if (value==null) {
      return "Seleccine una opción.";
    }
    return null;
  }
  String validateFechaInicio(String value) {
    if (value.length == 0) {
      return "La fecha de inicio es requerido.";
    }
    return null;
  }
  String validateFechaFin(String value) {
    if (value.length == 0) {
      return "La fecha de finalización es requerido.";
    }
    return null;
  }

}
