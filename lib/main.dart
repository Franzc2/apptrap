
import 'package:app/locator.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/buscar_empleos_page.dart';
import 'package:app/ui/views/chats_user_page.dart';
import 'package:app/ui/views/mis_postulaciones_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/views/curriculum_page.dart';
import 'package:app/ui/views/personal_information_page.dart';
import 'package:app/ui/views/search_publications_page.dart';
import 'package:app/ui/views/login_page.dart';
import 'package:app/ui/views/home_page.dart';
import 'package:app/ui/views/principal_page.dart';
import 'package:app/ui/views/mis_publicaciones_page.dart';

import 'locator.dart';
import './core/viewmodels/crudModel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>LoginState()),
          ChangeNotifierProvider(create: (_)=>locator<crudModel>()),
        ],

        child: Consumer<LoginState>(
            builder:(context,state,_){
              return  MaterialApp(
                localizationsDelegates: [
                  // ... delegado[s] de localización específicos de la app aquí
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: [
                  const Locale('en'), // Inglés
                  const Locale('es'), // Español
//                  const Locale.fromSubtags(languageCode: 'zh'), // Chino *Mira Localizaciones avanzadas más abajo*
                  // ... otras regiones que la app soporte
                ],
                debugShowCheckedModeBanner: false,
                title: 'Flutter Login Demo',
                theme: new ThemeData(
                  primarySwatch: Colors.blue,
                ),
                initialRoute: '/',
                routes: {
                  '/': (context)=>PrincipalPage(),
                  '/login': (context)=> LoginPage(),
                  '/searchCategories': (context)=>SearchCategoriesPage(),
                  '/personalInformationPage':(context)=> PersonalInformationPage(),
                  '/curriculumPage':(context)=>CurriculumPage(user: state.user,),
                  '/homePage': (context)=>HomePage(),
                  '/misPublicaciones': (context)=>MisPublicacionesPage(),
                  '/misPostulaciones': (context)=>MisPostulacionesPage(),
                  '/chatsUserPage': (context)=> ChatsUserPage(),
                  '/buscarEmpleosPage': (context)=>BuscarEmpleosPage()
                },
              );
            }
        ),
    );
  }
}


