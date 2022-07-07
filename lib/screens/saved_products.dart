import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_market/services/firestore_services.dart';
import 'package:open_market/widgets/product_card.dart';

class SavedProducts extends StatefulWidget {
  @override
  _SavedProductsState createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  List? savedProducts = [];

  _getSavedList()async{

    try{
      savedProducts = await FireStoreServices().getSavedList(userId);
      setState(() {

        });

    }catch(error){

    }
  }
  @override
  void initState() {
    _getSavedList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        title: Text('Saved products',style: TextStyle(color: Color(0xff292d32)),),
      ),
      body: RefreshIndicator(
        onRefresh: () => _getSavedList() ,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: savedProducts!.isEmpty?null:FirebaseFirestore.instance
                .collection('products')
                .where('id', whereIn: savedProducts)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                          imageUrl: snapshot.data!.docs[index]['image'][0],
                          sellerId: snapshot.data!.docs[index]['seller'],
                          productId:snapshot.data!.docs[index]['id'] ,
                          title: snapshot.data!.docs[index]['title'],
                          price: snapshot.data!.docs[index]['price'],
                          date: snapshot.data!.docs[index]['date'],

                        );
                      });
                } else if(snapshot.data!.docs.isEmpty){
                  return Center(
                    child: Text('There no items'),
                  );
                }
              }
              return Center(
                  child: Image(
                    image: AssetImage('images/empty.png'),
                    height: 100,
                    width: 100,
                  ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
