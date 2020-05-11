import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/ui/views/home_page.dart';
import 'package:app/ui/views/login_page.dart';
import 'package:app/core/viewmodels/login_state.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() {
    return _PrincipalPageState();
  }
}

class _PrincipalPageState extends State<PrincipalPage> {
  SharedPreferences _prefs;
  bool _loginUser;

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
    return Consumer<LoginState>(
      builder: (context, state,_){
        if(state.isLoading()==true){
          return Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        else{
          if(state.isLoggedIn()){
            return HomePage();
          }else{
            return LoginPage();
          }
        }
      },
    );
  }
}
