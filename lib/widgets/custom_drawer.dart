import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_market/auth_screens/splash_screen.dart';
import 'package:open_market/screens/add_product.dart';
import 'package:open_market/screens/profile.dart';
import 'package:open_market/screens/saved_products.dart';
import 'package:open_market/services/auth_services.dart';

import 'custom_list_tile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoading = false;
  String? _name = '';
  String? _imageUrl = '';
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  void getUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get();
      if (documentSnapshot.data() != null) {
        setState(() {
          _name = documentSnapshot.get('name');
          _imageUrl = documentSnapshot.get('image');
        });
      }

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
  @override
  Widget build(BuildContext context) {
  final  double screenWidth = MediaQuery.of(context).size.width;
  final FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
                children: [
                  Container(
                    height: screenWidth*0.3,
                    width: screenWidth*0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
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
                  Text('$_name',style: TextStyle(color: Colors.black,fontSize: 16.0),)
                ],
              ),),
          CustomListTile(title: 'My Account',
          icon: Icons.account_circle_outlined,
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(userId: auth.currentUser!.uid,)));

          },),
          CustomListTile(title: 'My Products',
            icon: Icons.apps_outlined,
            onTap: (){

            },),
          CustomListTile(title: 'Saved Items',
            icon: Icons.book_outlined,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedProducts()));

            },),
          CustomListTile(title: 'Add Product',
            icon: Icons.add_box_outlined,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));

            },),
          Divider(color: Colors.grey,),
          CustomListTile(title: 'Logout',
            icon: Icons.logout,
            onTap:(){
            _logout();
              // GlobalMethods().alertDialog(
              //     message: 'Are you sure ?',
              //     ctx:context,
              //     submit: 'Yes',
              //     image: 'images/logout.png',
              //     action: 'Logout',
              //     onAction: (){
              //       _logout();
              //   }
              // );
            }
              // _logout(context);

  ),
        ],
      ),
    );
  }

  void _logout() async{
    await AuthService().singOut().then((value) => {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoadingScreen())),
      Navigator.canPop(context) ? Navigator.pop(context) : null,
    });

  }
}
