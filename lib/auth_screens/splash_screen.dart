import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_market/auth_screens/user_state.dart';
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>SplashScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitSquareCircle(
          itemBuilder: (context,index){
            return CircleAvatar(
              radius: 70.0,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('images/app_logo.png'),
            );
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
     final Future<FirebaseApp> init = Firebase.initializeApp();
    return FutureBuilder(
        future:init ,
        builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
          print('waiting');
         return Scaffold(
           body: Center(
             child: CircularProgressIndicator(),
           ),

         );
       }
       else if (snapshot.hasData) {
         print('data');
         return UserState();
       }
       else{
         return Scaffold(
           body: Center(
             child: Text('${snapshot.error}'),
           ),

         );
       }

        });
  }
}