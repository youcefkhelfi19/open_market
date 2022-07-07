import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_market/auth_screens/splash_screen.dart';
import 'package:open_market/services/auth_services.dart';
import 'package:open_market/services/global_methods.dart';
import 'package:open_market/widgets/contact_widget.dart';
import 'package:open_market/widgets/custom_drawer.dart';
import 'package:open_market/widgets/product_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({required this.userId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isTheSameUser = false;
  String? _name = '';
  String? _email = '';
  String? _phone = '';
  String? _imageUrl = '';
  String? _location = '';
  void getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (documentSnapshot.data() != null) {
        setState(() {
          _name = documentSnapshot.get('name');
          _email = documentSnapshot.get('email');
          _phone = documentSnapshot.get('phone');
          _location = documentSnapshot.get('location');
          _imageUrl = documentSnapshot.get('image');
        });
      }

      final _uid = FirebaseAuth.instance.currentUser!.uid;
      setState(() {
        _isTheSameUser = _uid == widget.userId;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('Editing');
        break;
      case 1:
        print('sharing');

        break;
      case 2:
        _logout();
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Color(0xff292d32),
            ),
            elevation: 0,
            backgroundColor: Colors.orange,
            actions: [
              !_isTheSameUser
                  ? Container()
                  : PopupMenuButton<int>(
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Edit Account'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Share'),
                                ],
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Sign Out'),
                                ],
                              ),
                            ),
                          ])
            ],
          ),
          bottomSheet: _isTheSameUser
              ? Container(
            height: 0.0,
            width: 0.0,
          )
              : Container(
            height: kBottomNavigationBarHeight * 1.2,
            color: Color(0xff292d32),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ContactWidget(
                    color: Colors.green,
                    function: () {
                      GlobalMethods().openWhatsapp(
                          '+213$_phone!', 'still available?');
                    },
                    icon: FontAwesomeIcons.whatsapp),
                ContactWidget(
                    color: Colors.red,
                    function: () {
                      GlobalMethods().openEmail(_email!);
                    },
                    icon: Icons.mail_outline),
                ContactWidget(
                    color: Colors.purple,
                    function: () {
                      GlobalMethods().makeCall(_phone!);
                    },
                    icon: Icons.call_outlined),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // textBaseline: TextBaseline.alphabetic,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: screenHeight * 0.15,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  AssetImage('images/map.PNG'),
                                              fit: BoxFit.fill),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                          ),
                                          color: Color(0xff292d32)),
                                    ),
                                    Container(
                                      height: 3,
                                      width: screenWidth,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          top: screenWidth * 0.2 / 2),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0)),
                                        color: Colors.orange,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(_name!,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff292d32))),
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: Color(0xff292d32),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                'Contact Info',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff292d32)),
                                              ),
                                            ),
                                          ),
                                          userInfo(
                                              title: 'Email:',
                                              content: _email!),
                                          userInfo(
                                              title: 'Phone number:',
                                              content: _phone!),
                                          userInfo(
                                              title: 'Address:',
                                              content: _location!),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    right: 5.0,
                                    top: 5.0,
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color(0xffE8DDC9),
                                          ),
                                          padding: EdgeInsets.all(3.0),
                                          child: InkWell(
                                              splashColor: Colors.orange,
                                              onTap: () {
                                                GlobalMethods()
                                                    .launchMapsUrl(_location!);
                                              },
                                              child: Icon(
                                                Icons.location_on_sharp,
                                                color: Colors.green,
                                              )),
                                        )
                                      ],
                                    )),
                                Positioned(
                                  top: screenHeight * 0.15 / 2,
                                  left: screenWidth * 0.65 / 2,
                                  child: Container(
                                    height: screenWidth * 0.3,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        image: _imageUrl == ''
                                            ? DecorationImage(
                                                image: AssetImage(
                                                    'images/man.png'),
                                                fit: BoxFit.fill)
                                            : DecorationImage(
                                                image: NetworkImage(_imageUrl!),
                                                fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Products',
                      style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff292d32)),
                    ),
                  ),
                  Container(
                      height: screenHeight * 0.5,
                      width: screenWidth,
                      padding: const EdgeInsets.all(10.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .where('seller', isEqualTo: widget.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            print('im here waiting');
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.data!.docs.isNotEmpty) {
                              return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return ProductCard(
                                      images: snapshot.data!.docs[index]['image'],
                                      sellerId:snapshot.data!.docs[index]['seller'] ,
                                      imageUrl: snapshot.data!.docs[index]
                                          ['image'][0],
                                      productId: snapshot.data!.docs[index]
                                          ['id'],
                                      title: snapshot.data!.docs[index]
                                          ['title'],
                                      price: snapshot.data!.docs[index]
                                          ['price'],
                                      date: snapshot.data!.docs[index]['date'],
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text('There no items'),
                              );
                            }
                          }
                          return Center(
                              child: Text(
                            'Something went wrong',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ));
                        },
                      ),),

                ],
              ),
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

  Widget userInfo({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff292d32),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              content,
              style: TextStyle(
                color: Color(0xff292d32),
                fontSize: 18,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    GlobalMethods().alertDialog(
        message: 'Are you sure ?',
        ctx:context,
        submit: 'Yes',
        image: 'images/logout.png',
        action: 'Logout',
        onAction: ()async{
          print('working');

          await AuthService().singOut().then((value) => {
            print('working'),
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoadingScreen())),

          });

        }
    );
  }
}
