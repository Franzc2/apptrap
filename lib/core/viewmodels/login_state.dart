
import 'package:app/core/models/publicacionTrabajoUserModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/viewmodels/crudModel.dart';
import 'package:app/core/models/userModel.dart';
import 'package:app/core/models/expProfesionalModel.dart';
import 'package:app/core/models/formacionModel.dart';

final String TWITTER_API="B4u7tLP13AiUSt9pA8qEq4LXm";
final String TWITTER_SECRET="fIUFlVRGL2eNBHdOQhFueVHURRI3vumROshlPghOnZtrO1epdZ";

enum LoginProvider{
  GOOGLE,
  TWITTER,
  FACEBOOK
}

class LoginState with ChangeNotifier{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookSignIn= FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _prefs;
  final crudModel userCrud=new crudModel();

  // primero definimos un objeto de tipo Login para consumir
  final TwitterLogin _twitterLogin= new TwitterLogin(
    consumerKey: TWITTER_API,
    consumerSecret: TWITTER_SECRET
  );

  User user=new User(urlImagePerfil: '',nombreCompleto: '',correoElectronico: '',id: '');
  List<ExpProfesional> _expProfUser=[];
  List<Formacion> _formacionUser=[];

  FirebaseUser _user;
  bool _loggedIn = false;
  bool _loading = false;

  LoginState(){
    loginState();
  }

  FirebaseUser getUserFirebase(){
    return _user;
  }

  bool isLoggedIn()=> _loggedIn;
  bool isLoading()=> _loading;
  User infoUser()=> user;
  String getIdUser()=> user.id;
  List<ExpProfesional> expProfUser()=>_expProfUser;
  List<Formacion> formacionUser()=>_formacionUser;

  ///////
  void login(LoginProvider loginProvider) async{
    _loading = true;
    notifyListeners();
    switch (loginProvider){
      case LoginProvider.GOOGLE:
        _user =await _handleSignIn().catchError((e){_loading=false;});
        break;
      case LoginProvider.FACEBOOK:
        _user =await _handleFacebookSignIn().catchError((e){_loading=false;});
        break;
      case LoginProvider.TWITTER:
        _user =await _handleTwitterSignIn().catchError((e){ print(e); _loading=false;});
        break;
    }

    /// condicion para user logueado
    _loading = false;
    if(_user != null){
      _prefs.setBool('isLoggedIn', true);
      await cargarDatosUser(_user.uid);
      _loggedIn=true;
      notifyListeners();
    }
    else{
      _loggedIn=false;
      notifyListeners();
    }
  }

  void logout(){
    _prefs.clear();
    _googleSignIn.signOut();
    _facebookSignIn.logOut();
    _twitterLogin.logOut();
    _loggedIn=false;
    limpiarUser();

    notifyListeners();
  }

  limpiarUser(){
    user.id='';
    user.urlImagePerfil='';
    user.correoElectronico='';
    user.nombreCompleto='';
    user.estadoCuenta='';
    user.idiomas=[];
    user.habilidades=[];
    user.urlDocumentCurriculum='';
    user.fechaNacimiento=null;
    user.telefonoCelular='';
    user.ciudadRecidencia='';
    user.numCI='';
    user.nameDocCurriculum="";
    user.token="";

    _expProfUser=[];
    _formacionUser=[];

  }

  Future<void> cargarDatosUser(String idUser)async{
    user=await userCrud.getUserById(idUser);
//    notifyListeners();
    if(user==null){
      print('el usuario aun no esta registrado en la base de datos.');
      await registrarUser(idUser);
    }
    else{
      _expProfUser= await userCrud.getExperienceProfUser(idUser);
      _formacionUser= await userCrud.getFormacionUser(idUser);
      print('el usuario ya esta registrado en la base de datos.');
    }
    notifyListeners();
  }

  Future<void> cargarInformacionPersonal(String idUser)async{
    user=await userCrud.getUserById(idUser);
    notifyListeners();
  }

  cargarExperienciaProfesionalUser(String idUser)async{
    _expProfUser= await userCrud.getExperienceProfUser(idUser);
    notifyListeners();
  }

  cargarFormacionUser(String idUser)async{
    _formacionUser= await userCrud.getFormacionUser(idUser);
    notifyListeners();
  }



  registrarUser(String id)async{
    await userCrud.addUser(
        User(
          nombreCompleto: _user.displayName,
          correoElectronico: _user.email,
          urlImagePerfil: _user.photoUrl,
          telefonoCelular: '',
          ciudadRecidencia: '',
          estadoCuenta: '1',
          habilidades:[],
          idiomas: [],
          numCI: '',
          urlDocumentCurriculum: '',
          nameDocCurriculum: '',
          token: '',
        ),
        id
    );
    print("el usuario nuevo ya fue registrado");
    user=await userCrud.getUserById(id);
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    print("url image "+ user.photoUrl);
    print("uid"+ user.uid);
    return user;
  }
    /// obtener credecial de FACEBOOK
    Future<FirebaseUser> _handleFacebookSignIn() async{
    final result= await _facebookSignIn.logIn(['email']);
    if (result.status != FacebookLoginStatus.loggedIn){
      return null;
    }
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    print("url image "+ user.photoUrl);
    print("uid"+ user.uid);
    print("correo"+ user.email);
    return user;
  }
  //obtenemos el credencial TWITTER
  Future<FirebaseUser> _handleTwitterSignIn() async{
    var twiterResult = await _twitterLogin.authorize(); // maneja toda la logica para menejar el usuario
    if(twiterResult.status != TwitterLoginStatus.loggedIn){
      return null;
    }
    var session=twiterResult.session;
    final AuthCredential credential= TwitterAuthProvider.getCredential(
        authToken: session.token,
        authTokenSecret: session.secret,
    );

    final FirebaseUser user= (await _auth.signInWithCredential(credential)).user;
    print("correo electronico" + user.email);
    print("signed in " + user.displayName);
    return user;
  }
  /// fin de future Twitter

  void loginState()async{
    _loading=true;
    _prefs= await SharedPreferences.getInstance();
    if(_prefs.containsKey('isLoggedIn')){
      _user=await _auth.currentUser();
      _loggedIn= _user !=null;
      await cargarDatosUser(_user.uid);
      _loading=false;
      notifyListeners();
    }
    else{
      _loading=false;
      notifyListeners();
    }
  }

}