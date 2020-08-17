import 'package:app/core/models/chatModel.dart';
import 'package:app/core/models/mensajeModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatsUserPage extends StatefulWidget {
  ChatsUserPage({Key key}) : super(key: key);

  @override
  _ChatsUserPageState createState() {
    return _ChatsUserPageState();
  }
}

class _ChatsUserPageState extends State<ChatsUserPage> {
  List<Chat> chats;
  var formatFecha = DateFormat.yMd('es');
  var formatHora = DateFormat.jm();


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
    var crud=Provider.of<crudModel>(context);
    final infoUser=Provider.of<LoginState>(context).infoUser();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
        title: Text('Bandeja de entrada'),
      ),
      body:Container(
        child: StreamBuilder(
          stream: crud.streamChatsUser(infoUser.id),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              chats= snapshot.data.documents
                  .map((doc)=>Chat.fromMap(doc.data, doc.documentID))
                  .toList();
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (buildContext, index){
                  Chat chat=chats[index];
                  String idOtroUser=infoUser.id==chat.idUser1? chat.idUser2: chat.idUser1;
                  return
                    FutureBuilder(
                      future: crud.getUserById(idOtroUser),
                      builder: (buildContext, userSnap){
                        if(userSnap.connectionState==ConnectionState.waiting){
                          return Container();
                        }
                        else{
                          User otroUser=userSnap.data;
                          return
                            StreamBuilder(
                              stream: crud.mensajesChatStream(chat.id),
                              builder: (buildContext, AsyncSnapshot<QuerySnapshot> snapshot){
                                if(snapshot.hasData){
                                  List<Mensaje> mensajes;
                                  mensajes=snapshot.data.documents
                                      .map((doc)=>Mensaje.fromMap(doc.data, doc.documentID))
                                      .toList();
                                  if(mensajes.length==0){
                                    return Container();
                                  }
                                  else{
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: ClipOval(child: Image.network(otroUser.urlImagePerfil),),
                                          radius: 25.0,
                                        ),
                                        title: Text(otroUser.nombreCompleto),
                                        subtitle: Text(mensajes.first.contenidoMensaje),
                                        trailing:Column(
                                          children: <Widget>[
//                                            Text(formatFecha.format(mensajes.first.fechaMensaje.toDate()),style: TextStyle(fontSize: 10.0),)
                                          Container(
                                            child: formatFecha.format(mensajes.first.fechaMensaje.toDate())==formatFecha.format(DateTime.now())
                                                ?Text(formatHora.format(mensajes.first.fechaMensaje.toDate()),style: TextStyle(fontSize: 12.0),)
                                                :Text(formatFecha.format(mensajes.first.fechaMensaje.toDate()),style: TextStyle(fontSize: 12.0))
                                          ),
                                          Container(
                                            child: infoUser.id==chat.idUser1
                                                ?Container(height: 25.0,width: 25.0, child: chat.numeroMensajesNuevosParaIdUser1==0?Container():Container(decoration:BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.all(Radius.circular(12.0))),child: Center(child: Text(chat.numeroMensajesNuevosParaIdUser1.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),))
                                                :Container(height: 25.0,width: 25.0, child: chat.numeroMensajesNuevosParaIdUser2==0?Container():Container(decoration:BoxDecoration(color: Colors.amber,borderRadius: BorderRadius.all(Radius.circular(12.0))),child: Center(child: Text(chat.numeroMensajesNuevosParaIdUser2.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),))
                                          )

                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(chat: chat,otroUser: otroUser,)));
                                        },
                                      ),
                                    );
                                  }
                                }
                                else{
                                  return Container();
                                }
                              },
                            );
                        }
                      },
                    );
                },
              );

            }
            else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}

//child:
//CircleAvatar(
//radius: 45.0,
//child: ClipOval( child: Image.network(infoUser.urlImagePerfil,width: 80,height: 80,fit: BoxFit.cover,),
//),
//)