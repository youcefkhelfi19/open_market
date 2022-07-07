import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_market/services/firestore_services.dart';
import 'package:open_market/services/global_methods.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  List<File> _images = [];
  final _formKey = GlobalKey<FormState>();
  var _productTitle = '';
  var _productPrice = '';
  var _productCategory = '';
  var _productDescription = '';
  bool _isLoading = false;
  final TextEditingController _categoryController = TextEditingController();
  String? _categoryValue;


  void _uploadProduct() async {
    if (_formKey.currentState!.validate()&&_images.length>0) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        var productId = Uuid().v4();

        List imagesLinks = await FireStoreServices().uploadImage(images: _images,productId: productId);
       await FireStoreServices().uploadProduct(
         productId: productId,
         title: _productTitle,
         sellerId: auth.currentUser!.uid,
         price: _productPrice,
         category: _categoryController.text,
         imagesLinks: imagesLinks,
         description: _productDescription,
         comments: ['comment1','comment2','comment3']
       ).whenComplete(() =>{
         GlobalMethods().toast(message: 'Product has been added'),
           setState(() {
              _productTitle = '';
              _productPrice = '';
              _productCategory = '';
              _productDescription = '';
       _images = [];
       })
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

  void selectImagesFromGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
      _images.add(File(pickedImage!.path));
    });
    retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _images.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  void selectImagesFromCamera() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    setState(() {
      _images.add(File(pickedImage!.path));
    });
    retrieveLostData();
  }


  void _removeImage() {
    setState(() {
      _images = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.orange,
              title: Text(
                'Add Product',
                style: TextStyle(color: Color(0xff292d32)),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                    onPressed: () {
                      _uploadProduct();
                    },
                    icon: Icon(Icons.check,color: Color(0xff292d32),),)
              ],
              elevation: 0.0),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Card(
                    margin: EdgeInsets.all(15),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: TextFormField(
                                      key: ValueKey('Title'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a Title';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Product Title',
                                      ),

                                      onSaved: (value) {
                                        _productTitle = value!;
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextFormField(
                                    key: ValueKey('Price DA'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Price is missed';
                                      }
                                      return null;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    decoration: InputDecoration(
                                        labelText: 'Price \DA',
                                        focusColor: Colors.black),
                                    //obscureText: true,
                                    onSaved: (value) {
                                      _productPrice = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            /* Image picker here ***********************************/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //  flex: 2,
                                  child: this._images.length == 0
                                      ? Container(
                                          margin: EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          child: GridView.builder(
                                              itemCount: _images.length ,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                              itemBuilder: (BuildContext context, int index) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: FileImage(_images[index]),
                                                      fit: BoxFit.fill
                                                    )
                                                  ),
                                                );
                                              },)
                                        ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: TextButton.icon(
                                        // textColor: Colors.white,
                                        onPressed: selectImagesFromCamera,
                                        icon: Icon(Icons.camera,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Camera',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: TextButton.icon(
                                        onPressed: selectImagesFromGallery,
                                        icon: Icon(Icons.image,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Gallery',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      child: TextButton.icon(
                                        onPressed: _removeImage,
                                        icon: Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.red,
                                        ),
                                        label: Text(
                                          'Remove',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            //    SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  // flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller: _categoryController,

                                        key: ValueKey('Category'),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a Category';
                                          }
                                          return null;
                                        },
                                        //keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Category',
                                        ),
                                        onSaved: (value) {
                                          _productCategory = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownButton<String>(
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text('S-Phone'),
                                      value: 'S-Phone',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Clothes'),
                                      value: 'Clothes',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Vehicles'),
                                      value: 'Vehicles',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Tools'),
                                      value: 'Tools',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Laptops'),
                                      value: 'Laptops',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Consoles'),
                                      value: 'Consoles',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Books'),
                                      value: 'Books',
                                    ),

                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _categoryValue = value;
                                      _categoryController.text = value!;
                                      //_controller.text= _productCategory;
                                      print(_productCategory);
                                    });
                                  },
                                  hint: Text('Select a Category'),
                                  value: _categoryValue,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                                key: ValueKey('Description'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'product description is required';
                                  }
                                  return null;
                                },
                                //controller: this._controller,
                                maxLines: 10,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  //  counterText: charLength.toString(),
                                  labelText: 'Description',
                                  hintText: 'Product description',
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _productDescription = value!;
                                },
                                onChanged: (text) {
                                }),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
        _isLoading
            ? Scaffold(
            backgroundColor: Colors.white10,
            body: Center(
              child: CircularProgressIndicator(),
            ))
            : Container(
          height: 0.0,
          width: 0.0,
          color: Colors.red,
        )
      ],
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
