import 'package:app/core/models/expProfesionalModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/core/models/userModel.dart';


class AgregarExpProfesionalPage extends StatefulWidget {
  final User user;
  AgregarExpProfesionalPage({Key key, this.user}) : super(key: key);

  @override
  _AgregarExpProfesionalPageState createState() {
    return _AgregarExpProfesionalPageState();
  }
}

class _AgregarExpProfesionalPageState extends State<AgregarExpProfesionalPage> {


  String fechaInicioFire="";
  String fechaFinFire="";

  final formatFechaTextField= new DateFormat('dd-MM-yyyy');
  final formatFechaForFire= new DateFormat('yyyy-MM-dd');

  GlobalKey<FormState> keyForm = new GlobalKey();
  TextEditingController empresaCtrl= new TextEditingController();
  TextEditingController cargoCtrl= new TextEditingController();
  TextEditingController regionCtrl= new TextEditingController();
  TextEditingController fechaInicioCtrl= new TextEditingController();
  TextEditingController fechaFinCtrl= new TextEditingController();
  TextEditingController funcionesCtrl= new TextEditingController();

  DateTime Fecha_inicio;

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
        title: Text("Agregar Exp. Profesional"),
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
                  labelText: "Empresa",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business)
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType:TextInputType.text ,
              controller: empresaCtrl,
              validator: validateEmpresa,
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Cargo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment_ind),
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: cargoCtrl,
              validator: validateCargo,
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Región",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: regionCtrl,
              validator: validateRegion,
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Fecha inicio",
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
            SizedBox(height: 15,),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Fecha fin",
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
            SizedBox(height: 15,),
            TextFormField(
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  labelText: "Funciones",
                border: OutlineInputBorder(),
//                  prefixIcon: Icon(Icons)
              ),
              controller: funcionesCtrl,
              validator: validateFunciones,
            ),
            SizedBox(height: 15,),
            Container(
              child:
              RaisedButton(
                color: Color.fromRGBO(63, 81, 181, 1),
                child: Text("Guardar",style: TextStyle(fontSize: 18,color: Colors.white),),
                onPressed: ()async{

                  if (keyForm.currentState.validate()) {
                      print("empresa ${empresaCtrl.text}");
                      print("cargo ${cargoCtrl.text}");
                      print("region ${regionCtrl.text}");
                      print("fecha inicio ${fechaInicioCtrl.text}");
                      print("fecha fin ${fechaFinCtrl.text}");
                      print("funciones ${funcionesCtrl.text}");
                      
//                      keyForm.currentState.reset();

                      await expProfProvider.addExpProfUser(
                        widget.user.id,
                        ExpProfesional(
                          fechaCreacion: Timestamp.fromDate(DateTime.now()),
                          empresa: empresaCtrl.text,
                          cargo: cargoCtrl.text,
                          region: regionCtrl.text,
                          fechaInicio: Timestamp.fromDate(DateTime.parse(fechaInicioFire)),
                          fechaFin: Timestamp.fromDate(DateTime.parse(fechaFinFire)),
                          funciones: funcionesCtrl.text,
                        )
                      );
                      loginState.cargarExperienciaProfesionalUser(widget.user.id);
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
  String validateEmpresa(String value) {
    if (value.length == 0) {
      return "El nombre de la Empresa es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateCargo(String value) {
    if (value.length == 0) {
      return "El Cargo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }
  String validateRegion(String value) {
    if (value.length == 0) {
      return "La región es requerida.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
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
  String validateFunciones(String value) {
    if (value.length == 0) {
      return "Este campo es requerido.";
    } else if (value.length<4) {
      return "Debe contener al menos 4 caracteres.";
    }
    return null;
  }

}