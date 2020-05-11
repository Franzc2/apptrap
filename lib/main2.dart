import 'package:app/locator.dart';

import 'package:app/core/viewmodels/login_state.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/views/login_page.dart';
import 'package:app/ui/views/home_page.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/views/agregar_exp_profesional_page.dart';
import 'package:app/ui/views/curriculum_page.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:app/ui/views/search_publications_page.dart';


import 'locator.dart';
import './core/viewmodels/crudModel.dart';

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>LoginState()),
      ChangeNotifierProvider(create: (_)=>locator<crudModel>()),
    ],
      child: Consumer<LoginState>(
          builder: (context, state, _){
            return MaterialApp(
              title: 'Flutter Login Demo',
              debugShowCheckedModeBanner: false,
              theme: new ThemeData(
                primarySwatch: Colors.blue,
              ),
              routes: {
                '/':(BuildContext context){
                  if(state.isLoggedIn()){
                    return HomePage();
                  } else{
                    return LoginPage();
                  }
                },
                '/login': (BuildContext context)=> LoginPage(),
                '/searchCategories': (BuildContext context)=>SearchCategoriesPage(),
                '/personalInformationPage':(BuildContext context)=>PersonalInformationPage(),
                '/curriculumPage':(BuildContext context)=>CurriculumPage(),
                '/homePage': (BuildContext context)=>HomePage(),
              },
            ) ;
          }
      ),
    );
  }
}


