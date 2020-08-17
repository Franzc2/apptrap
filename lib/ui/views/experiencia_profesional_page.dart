import 'package:app/core/models/expProfesionalModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExperienciaProfesionalPage extends StatefulWidget {
  final User userPostulante;
  ExperienciaProfesionalPage({Key key,this.userPostulante}) : super(key: key);

  @override
  _ExperienciaProfesionalPageState createState() {
    return _ExperienciaProfesionalPageState();
  }
}

class _ExperienciaProfesionalPageState extends State<ExperienciaProfesionalPage> {
  var formatFecha = DateFormat.yMMMMd('es');
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
        title: Text('Exp. profesional'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _crud.getExperienceProfUser(widget.userPostulante.id),
          builder: ( context ,  experienciasProfesionalesSnap ){
            if(experienciasProfesionalesSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(experienciasProfesionalesSnap.data.length==0){
                return
                  Center(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Icon(Icons.style,size: 120.0,color: Color.fromRGBO(197, 202, 232, 1.0),),
                        SizedBox(height: 10,),
                        Center(
                          child: Text("No se encontraron registros.",style: TextStyle(color: Colors.black38),),
                        ),
                      ],
                    ),
                  );
              }
              else{
                return ListView.builder(
                  itemCount: experienciasProfesionalesSnap.data.length,
                  itemBuilder: (_, index){
                    ExpProfesional expProfesional=experienciasProfesionalesSnap.data[index];
                    return
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            leading: Icon(Icons.work),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                expProfesionalItem("Región", expProfesional.region),
                                expProfesionalItem("Empresa", expProfesional.empresa),
                                expProfesionalItem("Cargo", expProfesional.cargo),
                                Text("Funciones:",style: TextStyle(fontSize: 14.0),),
                                expProfesionalItem2( expProfesional.funciones),
                                expProfesionalItem("Fecha inicio", formatFecha.format(expProfesional.fechaInicio.toDate())),
                                expProfesionalItem("Fecha fin", formatFecha.format(expProfesional.fechaFin.toDate())),
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                  padding:EdgeInsets.all(8),
                );
              }

            }
          },
        ),
      ),
    );
  }
  Widget expProfesionalItem(String nombre, String detalle){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children: [
              TextSpan(text: nombre+': '),
              TextSpan(text: detalle,style: TextStyle(fontWeight: FontWeight.bold,)),
            ]
        ),
      ),
    );
  }
  Widget expProfesionalItem2(String detalle){
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children: [
              TextSpan(text: detalle,style: TextStyle(fontWeight: FontWeight.bold,)),
            ]
        ),
      ),
    );
  }
}