import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_market/services/auth_services.dart';
import 'package:open_market/services/global_methods.dart';
import 'package:open_market/widgets/custom_text_field.dart';
import 'package:open_market/widgets/password_text_field.dart';
import 'package:open_market/widgets/small_button.dart';

AuthService authService = AuthService();

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailTextController =
      TextEditingController(text: '');
  late TextEditingController _passwordTextController =
      TextEditingController(text: '');
  FocusNode passwordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  bool _isLoading = false;
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authService
            .createAccount(_emailTextController.text.trim().toLowerCase(),
                _passwordTextController.text.trim())
            .then((value) => {
                  setState(() {
                    _isLoading = false;
                  }),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => UserInfo()))
                });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _errorAlert(error);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordTextController.dispose();
    _emailTextController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0.0,
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
                  'Create To Your \nAccount',
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
                      onEditComplete: () => FocusScope.of(context)
                          .requestFocus(confirmPasswordNode),
                      hint: 'Password',
                      labelText: 'Password',
                      onValidate: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Please enter a valid Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    PasswordTextField(
                      node: confirmPasswordNode,
                      hint: 'Confirm password',
                      labelText: 'Confirm Password',
                      onValidate: (value) {
                        if (value.isEmpty ||
                            value != _passwordTextController.text) {
                          return 'Passwords don\'t match ';
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
                  child: _isLoading
                      ? SpinKitThreeInOut(
                          itemBuilder: (BuildContext context, int index) {
                            return CircleAvatar(
                              backgroundColor: Colors.black,
                            );
                          },
                        )
                      : SmallButton(
                          text: 'Next',
                          onPressed: () {
                            _submit();
                          })),
            ],
          ),
        ),
      ),
    );
  }

  void _errorAlert(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              '$message',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }
}

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _getLocation = false;
  late TextEditingController _userNameTextController =
      TextEditingController(text: '');
  late TextEditingController _phoneTextController =
      TextEditingController(text: '');
  late TextEditingController _locationTextController =
      TextEditingController(text: '');

  FocusNode phoneNode = FocusNode();
  FocusNode userNameNode = FocusNode();
  FocusNode locationNode = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  File? imageFile;
  var imageUrl ;
  @override
  void dispose() {
    phoneNode.dispose();
    userNameNode.dispose();
    locationNode.dispose();
    _userNameTextController.dispose();
    _phoneTextController.dispose();
    _locationTextController.dispose();
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
                  'Create To Your \nAccount',
                  style: TextStyle(
                      color: Color(0xff292d32),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        height: screenWidth * 0.3,
                        width: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Color(0xff292d32),
                            width: 1,
                          ),
                        ),
                        child: imageFile == null
                            ? Image.asset(
                                'images/man.png',
                                fit: BoxFit.fill,
                              )
                            : Image.file(
                                imageFile!,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: InkWell(
                          onTap: () {
                            _showImageDialog();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white30),
                              child: Icon(Icons.add)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    CustomTextField(
                      textValueController: _userNameTextController,
                      node: userNameNode,
                      onEditComplete: () =>
                          FocusScope.of(context).requestFocus(phoneNode),
                      hint: 'User Name',
                      labelText: 'Name',
                      valueKey: 'name',
                      icon: Icon(
                        Icons.person,
                        color: Color(0xff292d32),
                      ),
                      onValidate: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter a valid user name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextField(
                      textValueController: _phoneTextController,
                      textInputType: TextInputType.number,
                      node: userNameNode,
                      onEditComplete: () =>
                          FocusScope.of(context).requestFocus(phoneNode),
                      hint: 'Phone number',
                      labelText: 'Phone number',
                      valueKey: 'phone number',
                      icon: Icon(
                        Icons.phone,
                        color: Color(0xff292d32),
                      ),
                      onValidate: (value) {
                        if (value.isEmpty || value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    CustomTextField(
                      textValueController: _locationTextController,
                      node: userNameNode,
                      onEditComplete: () =>
                          FocusScope.of(context).requestFocus(phoneNode),
                      hint: 'Location',
                      labelText: 'Location',
                      valueKey: 'location',
                      suffixIcon:_getLocation?Icons.adjust_rounded :Icons.add_location_alt_sharp,
                      onSuffixTap: () {
                        getAddress();
                      },
                      icon: Icon(
                        Icons.storefront,
                        color: Color(0xff292d32),
                      ),
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return 'Please add a location';
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
                child:_isLoading?SpinKitThreeInOut(
                  itemBuilder: (BuildContext context, int index) {
                    return CircleAvatar(
                      backgroundColor: Color(0xff292d32),
                    );
                  },
                ): SmallButton(
                    text: 'Register',
                    onPressed: () {
                      _saveInfo();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getAddress()async{
    setState(() {
       _getLocation = true;
    });
    final current =  await GlobalMethods().getCurrentLocation();
    if(current != null){
      setState(() {
        _locationTextController.text = current;
        _getLocation = false;
      });
    }

  }
  void _saveInfo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {

        imageUrl = await authService.uploadImage(userId: auth.currentUser!.uid, file: imageFile);
        await authService.saveInfo(
          userId: auth.currentUser!.uid,
          email: auth.currentUser!.email,
          userName: _userNameTextController.text.trim(),
            phone: _phoneTextController.text.trim(),
            location:_locationTextController.text.trim(),
             imageUrl: imageUrl,
        ).then((value) => {
          Navigator.canPop(context) ? Navigator.pop(context) : null,
          GlobalMethods().toast(message: 'Account created'),
        });
      } catch (error) {
         GlobalMethods().alertDialog(message: '$error', ctx: context, image: 'images/close.png');
        setState(() {
          _isLoading = false;
        });
        _errorAlert(error);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    // _cropImage(pickedFile);
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    // _cropImage(pickedFile);

    Navigator.pop(context);
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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
