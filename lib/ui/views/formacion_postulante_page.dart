import 'package:app/core/models/formacionModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormacionPostulantePage extends StatefulWidget {
  final User userPostulante;
  FormacionPostulantePage({Key key, this.userPostulante}) : super(key: key);

  @override
  _FormacionPostulantePageState createState() {
    return _FormacionPostulantePageState();
  }
}

class _FormacionPostulantePageState extends State<FormacionPostulantePage> {
  var formatFecha = DateFormat.yMMMMd('es');
//  var formatHora = DateFormat.jm();
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
        title: Text('Formación'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _crud.getFormacionUser(widget.userPostulante.id),
          builder: ( context ,  formacionesSnap ){
            if(formacionesSnap.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              if(formacionesSnap.data.length==0){
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
                  itemCount: formacionesSnap.data.length,
                  itemBuilder: (_, index){
                    Formacion formacion=formacionesSnap.data[index];
                    return
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              leading: Icon(Icons.school),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  formacionItem("Institución", formacion.institucion),
                                  formacionItem("Nivel estudio", formacion.nivelEstudios),
                                  formacionItem("Fecha inicio", formatFecha.format(formacion.fechaInicio.toDate())),
                                  formacionItem("Fecha fin", formatFecha.format(formacion.fechaFin.toDate())),
                                  formacionItem("Estado formacion", formacion.estadoActualFormacion)
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
  Widget formacionItem(String nombre, String detalle){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: RichText(
        text: new TextSpan(
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children:<TextSpan> [
              TextSpan(text: nombre+': '),
              TextSpan(text: detalle,style: TextStyle(fontWeight: FontWeight.bold)),
            ]
        ),
      ),
    );
  }
}