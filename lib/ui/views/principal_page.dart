import 'package:app/ui/views/chats_user_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/ui/views/home_page.dart';
import 'package:app/ui/views/login_page.dart';
import 'package:app/core/viewmodels/login_state.dart';
import 'package:app/ui/views/onboarding_page.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() {
    return _PrincipalPageState();
  }
}

class _PrincipalPageState extends State<PrincipalPage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification(Map<String, dynamic> message) async {
    await _demoNotification(message);
  }

  Future<void> _demoNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        enableVibration: true,

//        category: ,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics,
        payload: 'test oayload');
  }

  @override
  void initState() {
    super.initState();


//estados de las notificaciones
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(message);
        print("onMessage: $message");
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatsUserPage()));
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatsUserPage()));
//        _navigateToItemDetail(message);
      },
    );
////fin estados notificaicnes
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    initializationSettings = new InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);
        initializationSettingsAndroid,initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

  }


  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatsUserPage()));
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
//            return OnboardingPage();
            return LoginPage();
          }
        }
      },
    );
  }
}
