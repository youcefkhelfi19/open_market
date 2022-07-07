import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:open_market/screens/add_product.dart';
import 'package:open_market/screens/home.dart';
import 'package:open_market/screens/profile.dart';
import 'package:open_market/screens/saved_products.dart';
import 'package:open_market/screens/search.dart';

class BottomNaviBar extends StatefulWidget {

  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  List<Widget> tabs = [];
  int currentTabIndex = 0;
  @override
  void initState() {
    tabs = [Home(),Search(),AddProduct(),SavedProducts(),ProfileScreen(userId: userId)];

    super.initState();
  }
  void selectTab(int index){
    setState(() {
      currentTabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        resizeToAvoidBottomInset: false,
        extendBody: true ,
        body:tabs[currentTabIndex],
        bottomNavigationBar: FloatingNavbar(
          selectedItemColor:Color(0xff292d32),
          selectedBackgroundColor: Colors.orange,
          backgroundColor: Color(0xff292d32),
          unselectedItemColor: Colors.orange,
          borderRadius: 30,
          onTap:selectTab,
          itemBorderRadius: 50,
          currentIndex: currentTabIndex,
          items: [
            FloatingNavbarItem(icon: Icons.storefront),
            FloatingNavbarItem(icon: Icons.search),
            FloatingNavbarItem(icon: Icons.add_box_outlined),
            FloatingNavbarItem(icon: Icons.bookmark),
            FloatingNavbarItem(icon: Icons.person),
          ],
        )

    );
  }
}
