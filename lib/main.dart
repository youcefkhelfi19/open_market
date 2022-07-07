import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_market/auth_screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
         accentColor: Colors.orange,
        primaryColor: Colors.orange,
        secondaryHeaderColor:Color(0xff292d32),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xff292d32),

        ),
        scaffoldBackgroundColor: Colors.white,

      ),
      debugShowCheckedModeBanner: false,
     home: LoadingScreen(),
    );
  }
}
