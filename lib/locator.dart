import 'package:app/core/services/apiCategoriaPublicacion.dart';
import 'package:app/core/services/apiChat.dart';
import 'package:app/core/services/apiPublicacionTrabajo.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:get_it/get_it.dart';

import './core/services/apiUser.dart';
import './core/viewmodels/crudModel.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiUser('users'));
  locator.registerLazySingleton(() => ApiCategoriaPublicacion('categorias'));
  locator.registerLazySingleton(() => ApiPublicacionTrabajo('publicaciones'));
  locator.registerLazySingleton(() => ApiChat('chats'));
  locator.registerLazySingleton(() => crudModel()) ;
//  locator.registerSingleton(() => LoginState());
}