import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_market/screens/profile.dart';
import 'package:open_market/services/firestore_services.dart';
import 'package:open_market/services/global_methods.dart';
import 'package:open_market/widgets/contact_widget.dart';

class Details extends StatefulWidget {
  Details({Key? key, required this.productId, required this.sellerId})
      : super(key: key);
  final String productId;
  final String sellerId;
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool _isLoading = false;
  bool _isTheSameUser = false;
  String? _sellerName = '';
  String? _phone = '';
  String? _sellerImageUrl = '';
  String? _email = '';
  String? _location = '';
  String? _postedDate ;
  String? _productTitle = '';
  String? _productPrice = '';
  String? _productDescription = '';
  String? _productCategory = '';
  List? _productImages = [];
  int _currentIndex = 0;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isSaved = false;
  IconData iconData = Icons.bookmark_border;
  List savedProducts = [];
  _getSavedList()async{
    try{
      savedProducts = await FireStoreServices().getSavedList(userId);
      for (String id in savedProducts) {
        if (id == widget.productId) {
          setState(() {
            iconData = Icons.bookmark;
          });
        }
      }
    }catch(error){

    }
  }
  void _savedUnsavedProduct()async{
    try{
      if(isSaved == false){
        await FireStoreServices().unsavedProduct(productId: widget.productId,userId: userId ).whenComplete((){
          GlobalMethods().toast(message: 'Product has been removed');
        });
        setState(() {
          iconData = Icons.bookmark_border;
        });
      }else{
        await FireStoreServices().saveProduct(productId: widget.productId,userId: userId ).whenComplete((){
          GlobalMethods().toast(message: 'Product saved');
        });
        setState(() {
          iconData = Icons.bookmark;
        });
      }
    }catch(e){
      print (e);
    }
  }
  void getDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.sellerId)
          .get();
      if (documentSnapshot.data() != null) {
        setState(() {
          _sellerName = documentSnapshot.get('name');
          _phone = documentSnapshot.get('phone');
          _email = documentSnapshot.get('phone');
          _location = documentSnapshot.get('location');
          _sellerImageUrl = documentSnapshot.get('image');
        });
      }
      final _uid = userId;
      setState(() {
        _isTheSameUser = _uid == widget.sellerId;
      });
      final DocumentSnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();
      if (productsSnapshot.data() != null) {
        setState(() {
          _productTitle = productsSnapshot.get('title');
          _productPrice = productsSnapshot.get('price');
          _productDescription = productsSnapshot.get('description');
          _productImages = productsSnapshot.get('image');
          _productCategory = productsSnapshot.get('category');
          Timestamp postedDateTimeStamp = productsSnapshot.get('date');
          var joinedDate = postedDateTimeStamp.toDate();
          _postedDate = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';

        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _errorAlert(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    _getSavedList();
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Details',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            elevation: 0.0,
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  isSaved = !isSaved;
                });
                _savedUnsavedProduct();
              }, icon: Icon(iconData,color: Colors.black,))
            ],
          ),
          bottomSheet: _isTheSameUser
              ? Container(
                  height: 0.0,
                  width: 0.0,
                )
              : Container(
                  height: kBottomNavigationBarHeight * 1.2,
                  color: Colors.white,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ContactWidget(
                          color: Colors.green,
                          function: () {
                            globalMethods.openWhatsapp(
                                '+213$_phone!', 'still available?');
                          },
                          icon: FontAwesomeIcons.whatsapp),
                      ContactWidget(
                          color: Colors.red,
                          function: () {
                            globalMethods.openEmail(_email!);
                          },
                          icon: Icons.mail_outline),
                      ContactWidget(
                          color: Colors.purple,
                          function: () {
                            globalMethods.makeCall(_phone!);
                          },
                          icon: Icons.call_outlined),
                    ],
                  ),
                ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                userId: widget.sellerId,
                              ))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        height: screenWidth * 0.1,
                        width: screenWidth * 0.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            image: _sellerImageUrl == ''
                                ? DecorationImage(
                                    image: AssetImage('images/man.png'),
                                    fit: BoxFit.fill)
                                : DecorationImage(
                                    image: NetworkImage(_sellerImageUrl!),
                                    fit: BoxFit.fill)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(_sellerName!,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      height: screenHeight * 0.4,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(
                          () {
                            _currentIndex = index;
                          },
                        );
                      },
                    ),
                    items: _productImages!
                        .map(
                          (item) => Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5.0),
                                image: DecorationImage(
                                    image: NetworkImage(item),
                                    fit: BoxFit.fill)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _productImages!.map((urlOfItem) {
                    int index = _productImages!.indexOf(urlOfItem);
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Color.fromRGBO(0, 0, 0, 0.8)
                            : Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _productTitle!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_productPrice DA',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  _productCategory!,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _location!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$_postedDate',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: screenHeight * 0.3,
                  child: Text(
                    _productDescription!,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
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
