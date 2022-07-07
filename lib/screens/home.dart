import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_market/constants.dart';
import 'package:open_market/models/category.dart';
import 'package:open_market/widgets/custom_drawer.dart';
import 'package:open_market/widgets/product_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
/// TODO refresh indicator in this lay

class _HomeState extends State<Home> {
  List<Category> categoriesList = categories;
   Future<void>_refreshing()async {
    FirebaseFirestore.instance
         .collection('products')
         .snapshots() ;
     setState(() {

     });
   }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categoriesList.length,
        child: Scaffold(
          drawer:CustomDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xff292d32)),
            backgroundColor: Colors.orange,
            elevation: 0.0,
            title: Text(
              'Home',
              style: TextStyle(color: Color(0xff292d32)),
            ),
            actions: [
              IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.message_outlined,
                    color: Color(0xff292d32),
                  ))
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: categoriesList.map<Widget>((Category category) {
                return Tab(
                  text: category.title,
                  icon: Icon(
                    category.icon,
                    color: Color(0xff292d32),
                  ),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: categoriesList.map<Widget>((Category category) {
              print(category);
              return RefreshIndicator(
                onRefresh: ()=>_refreshing(),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: category.title == 'All'
                          ? FirebaseFirestore.instance
                              .collection('products')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('products')
                              .where('category', isEqualTo: category.title)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          print('im here waiting');
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          print(category.title);

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
                                    imageUrl: snapshot.data!.docs[index]['image'][0],
                                    sellerId: snapshot.data!.docs[index]['seller'],
                                    productId:snapshot.data!.docs[index]['id'] ,
                                    title: snapshot.data!.docs[index]['title'],
                                    price: snapshot.data!.docs[index]['price'],
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
                    ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
