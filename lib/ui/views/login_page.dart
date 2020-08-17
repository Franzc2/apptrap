import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:app/core/viewmodels/login_state.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
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
    final Style01=TextStyle(color: Colors.black38);
    final loginState= Provider.of<LoginState>(context);

    // TODO: implement build
    return
      new Scaffold(
      body:
      ListView(
        children: <Widget>[
          Container(
            child: Image.asset("assets/images/loginbackg.png"),
          ),
//          SizedBox(
//            height: 80.0,
//          ),
//          Center(
//            child: Text("Trabajos Bolivia",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
//          ),
//          Container(
//            padding: EdgeInsets.all(20),
//            child: Center(
//                child: Column(
//                  children: <Widget>[
//                    Text("Te ayudamos a encontrar un trabajo mejor",textAlign: TextAlign.center,style: Style01,),
//                    Text("Haz que tu currículum sea visible para miles de empresas",textAlign: TextAlign.center,style: Style01,)
//                  ],
//                )
//            ),
//          ),

          Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: Text("Iniciar sesión", style: TextStyle(color: Colors.black87,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      padding: EdgeInsets.all(20),
                    ),
//                    Center(
//                      child: SizedBox(
//                          width: 270,
//                          height: 40,
//
//                          child: OutlineButton(
//                            onPressed: (){},
//                            child: new Container(
//                              child: Row(
//                                children: <Widget>[
//                                  Icon(Icons.person_outline),
//                                  Text("Usar correo electronico"),
//                                  Text("")
//                                ],
//                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              ),
//                            ),
//                          )
//                      ),
//                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                          width: 270,
                          height: 40,

                          child: OutlineButton(
                            onPressed: (){
                              loginState.login(LoginProvider.FACEBOOK);
                            },
                            child: new Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.facebook,color:Color.fromRGBO(66, 103, 178, 1)),
                                  Text("Continuar con Facebook"),
                                  Text("")
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                          width: 270,
                          height: 40,
                          child: OutlineButton(
                            onPressed: (){
                              loginState.login(LoginProvider.GOOGLE);
                            },
                            child: new Container(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: Image.asset("assets/logos/gmail-logo.png"),
                                  ),
                                  Text("Continuar con Google"),
                                  Text("")
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                          width: 270,
                          height: 40,
                          child: OutlineButton(
                            onPressed: (){
                              loginState.login(LoginProvider.TWITTER);
                            },
                            child: new Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.twitter,color: Color.fromRGBO(29, 161, 242, 1),),
                                  Text("Continuar con Twiter"),
                                  Text("")
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    Container(
                      child: RichText(
                        text: new TextSpan(
                            style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.black87,
                            ),
                            children: <TextSpan>[
                              new TextSpan(text: "Al continuar, confirmas que estás de acuerdo con los "),
                              new TextSpan(text: "Términos de uso ",style: TextStyle(fontWeight: FontWeight.bold)),
                              new TextSpan(text: "de Trabajos Bolivia y has leido la "),
                              new TextSpan(text: "Politica de Privacidad ",style: TextStyle(fontWeight: FontWeight.bold)),
                              new TextSpan(text: "de Trabajos Bolivia.")
                            ]
                        ),textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.only(right: 15,left: 15),
                    ),
                  ],
                ),

              )


            ],

          ),
        ],
      ),
    );
  }


}