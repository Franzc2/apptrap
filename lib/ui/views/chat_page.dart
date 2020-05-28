import 'package:app/core/models/chatModel.dart';
import 'package:app/core/models/mensajeModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  final User otroUser;
  ChatPage({Key key,this.chat,this.otroUser}) : super(key: key);

  @override
  _ChatPageState createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageEditingController = new TextEditingController();
  List<Mensaje> mensajes;
  var formatFecha = DateFormat.yMd('es');
//  DateFormat.jm()

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
    final crud=Provider.of<crudModel>(context);
    final User infoUser=Provider.of<LoginState>(context).infoUser();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.otroUser.nombreCompleto),
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      body: Container(
        child:
        Column(
          children: [
            Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: crud.mensajesChatStream1(infoUser.id,widget.chat.id),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.hasData){
                        mensajes=snapshot.data.documents
                            .map((doc)=>Mensaje.fromMap(doc.data, doc.documentID))
                            .toList();
                        print("se recargo los mensajes");
                        return ListView.builder(
                            itemCount: mensajes.length,
                            itemBuilder: (buildContext,index){
                              Mensaje mensaje=mensajes[index];
                              if(index==mensajes.length-1){
                                return Column(
                                  children: <Widget>[
                                    SizedBox(height: 15.0,),
                                    Text(formatFecha.format(mensaje.fechaMensaje.toDate())),
                                    MessageTile(
                                      message: mensaje.contenidoMensaje,
                                      sendByMe: infoUser.id == mensaje.idUser,
                                      fecha: mensaje.fechaMensaje,
                                    )
                                  ],
                                );
                              }
                              else{
                                String fecha1=formatFecha.format(mensaje.fechaMensaje.toDate());
                                String fecha2=formatFecha.format(mensajes[index+1].fechaMensaje.toDate());
                                if(fecha1!=fecha2){
                                  if(formatFecha.format(DateTime.now())==fecha1){
                                    return Column(
                                      children: <Widget>[
                                        Text("Hoy"),
                                        MessageTile(
                                          message: mensaje.contenidoMensaje,
                                          sendByMe: infoUser.id == mensaje.idUser,
                                          fecha: mensaje.fechaMensaje,
                                        )
                                      ],
                                    );
                                  }
                                  else{
                                    return Column(
                                      children: <Widget>[
                                        Text(fecha1),
                                        MessageTile(
                                          message: mensaje.contenidoMensaje,
                                          sendByMe: infoUser.id == mensaje.idUser,
                                          fecha: mensaje.fechaMensaje,
                                        )
                                      ],
                                    );
                                  }
                                }else{
                                  return MessageTile(
                                  message: mensaje.contenidoMensaje,
                                  sendByMe: infoUser.id == mensaje.idUser,
                                  fecha: mensaje.fechaMensaje,
                                  );
                                }
                              }
//                              return
//                               MessageTile(
//                                message: mensaje.contenidoMensaje,
//                                sendByMe: infoUser.id == mensaje.idUser,
//                                 fecha: mensaje.fechaMensaje,
//                              );
                            },
                            reverse: true,
                        );
                      }
                      else{
                        return Text("");
                      }
                  }
                  ),
                )
            ),
            Divider(height: 1.0,color: Colors.black26,),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child:
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Escribe un mensaje",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0)
                                )
                              ),
                          ),
                          keyboardType:TextInputType.text ,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 4,
                          controller: messageEditingController,
                        ),
                    ),
                    SizedBox(width: 10,),
                    FloatingActionButton(
                      onPressed: (){
                        if(messageEditingController.text==""){
                          print("el mensaje es nulo");
                        }
                        else{
                          crud.addMensaje(
                            widget.chat.id,
                            Mensaje(
                              contenidoMensaje: messageEditingController.text,
                              fechaMensaje: Timestamp.now(),
                              idUser: infoUser.id,
                              otroUserToken: widget.otroUser.token,
                              userUrlImagenPerfil: infoUser.urlImagePerfil,
                              userNombre: infoUser.nombreCompleto
                            )
                          );
                          messageEditingController.text="";
                        }
                      },
                      child: Icon(Icons.send),
                      backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final Timestamp fecha;

  MessageTile({@required this.message, @required this.sendByMe,@required this.fecha});

  var formatFecha = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    return
    Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 15,
          right: sendByMe ? 15 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 12, bottom: 12, left: 18, right: 18),
        decoration: BoxDecoration(
//          border: Border.all(width: 1,color: Colors.black38),
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: sendByMe ? Color.fromRGBO(63, 81, 181, 0.2):Colors.black12
        ),
        child: Column(
          children: <Widget>[
            Text(message,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'OverpassRegular',
                )),
            Container(
              child: Text(formatFecha.format(fecha.toDate()),style: TextStyle(fontSize: 10.0),),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        )
      ),
    );
  }
}