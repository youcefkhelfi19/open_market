import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_market/auth_screens/login.dart';
import 'package:open_market/widgets/custom_text_field.dart';
import 'package:open_market/widgets/small_button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextController = TextEditingController(text: '');
  FocusNode emailNode = FocusNode();
 @override
  void dispose() {
   _emailTextController.dispose();
   super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              child: AutoSizeText(
                'Login',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: screenHeight * 0.03),
                alignment: Alignment.bottomLeft,
                width: screenWidth,
                height: screenHeight * 0.2,
                child: AutoSizeText(
                  'Reset  Your \nPassword',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    CustomTextField(
                      textValueController: _emailTextController,
                      node: emailNode,
                      hint: 'Email',
                      labelText: 'Email',
                      valueKey: 'email',
                      icon: Icon(
                        Icons.email,
                        color: Color(0xff292d32),
                      ),
                      onValidate: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),

                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: screenWidth,
                height: screenHeight * 0.2,
                child:SmallButton(text: 'Send', onPressed: (){

                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
