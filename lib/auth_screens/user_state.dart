import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_market/auth_screens/login.dart';
import 'package:open_market/widgets/bottom_na_bar.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot){
          if(userSnapshot.connectionState ==  ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(userSnapshot.connectionState ==  ConnectionState.active){
            if(userSnapshot.hasData){

              return BottomNaviBar();
            }else{
              return Login();
            }
          }else if(userSnapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );

          }
          print('done');
          return Scaffold(
            body: Center(
              child: Text(userSnapshot.error.toString()),
            ),
          );
        });
  }
}
