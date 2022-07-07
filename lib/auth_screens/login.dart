import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_market/auth_screens/register.dart';
import 'package:open_market/auth_screens/reset_password.dart';
import 'package:open_market/services/auth_services.dart';
import 'package:open_market/services/global_methods.dart';
import 'package:open_market/widgets/custom_text_field.dart';
import 'package:open_market/widgets/password_text_field.dart';
import 'package:open_market/widgets/small_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailTextController =
      TextEditingController(text: '');
  late TextEditingController _passwordTextController =
      TextEditingController(text: '');
  FocusNode passwordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  AuthService authService = AuthService();

  bool _isLoading = false;
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
        await authService
            .singIn(_emailTextController.text.trim().toLowerCase(),
                _passwordTextController.text.trim())
            .then((value) => {
               Navigator.canPop(context) ? Navigator.pop(context) : null,
              GlobalMethods().toast(message: 'Welcome back'),
                });
        setState(() {
          _isLoading = false;
        });


    }
  }

  @override
  void dispose() {
    _passwordTextController.dispose();
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: AutoSizeText(
                'Register',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Color(0xff292d32)),
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
                  'Login To Your \nAccount',
                  style: TextStyle(
                      color: Color(0xff292d32),
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
                      onEditComplete: () =>
                          FocusScope.of(context).requestFocus(passwordNode),
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
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    PasswordTextField(
                      node: passwordNode,
                      textValueController: _passwordTextController,

                      hint: 'Password',
                      labelText: 'Password',
                      onValidate: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Please enter a valid Password';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPassword()));
                          },
                          child: AutoSizeText(
                            'Reset password ',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xff292d32)),
                          )),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: screenWidth,
                height: screenHeight * 0.2,
                child: _isLoading
                    ? SpinKitThreeInOut(
                        itemBuilder: (BuildContext context, int index) {
                          return CircleAvatar(
                            backgroundColor: Colors.black,
                          );
                        },
                      )
                    : SmallButton(
                        text: 'Login',
                        onPressed: () {
                          _submit();
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _errorAlert(message) {
    GlobalMethods().alertDialog(
        message: '$message',
        ctx:context,
        image: 'images/close.png',
        action: 'Error',

    );
  }
}
