import 'package:app/core/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformacionPersonalPostulantePage extends StatefulWidget {
  final User userPostulante;
  InformacionPersonalPostulantePage({Key key,this.userPostulante}) : super(key: key);

  @override
  _InformacionPersonalPostulantePageState createState() {
    return _InformacionPersonalPostulantePageState();
  }
}

class _InformacionPersonalPostulantePageState extends State<InformacionPersonalPostulantePage> {
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Inf. personal'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading:  CircleAvatar(
                    child: ClipOval(child: Image.network(widget.userPostulante.urlImagePerfil),),
                    radius: 25.0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      infoPersonalItem("Nombre", widget.userPostulante.nombreCompleto),
                      infoPersonalItem("Fecha nacimiento", formatFecha.format(widget.userPostulante.fechaNacimiento.toDate())),
                      infoPersonalItem("Ciudad residencia", widget.userPostulante.ciudadRecidencia),
                      infoPersonalItem("Telefono", widget.userPostulante.telefonoCelular),
                      infoPersonalItem("Nombre", widget.userPostulante.nombreCompleto),
                      infoPersonalItem("Correo electronico", widget.userPostulante.correoElectronico)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
  Widget infoPersonalItem(String nombre, String detalle){
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
}