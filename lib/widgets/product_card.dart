import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_market/screens/details.dart';
import 'package:open_market/services/firestore_services.dart';
import 'package:open_market/services/global_methods.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key,required this.images,  required this.sellerId,required this.productId,required this.imageUrl, required this.title, required this.price, required this.date}) : super(key: key);
   final String productId;
  final String imageUrl;
  final String title;
  final String price;
  final Timestamp date ;
  final String sellerId;
  final List images;
  @override
  _ProductCardState createState() => _ProductCardState();
}
class _ProductCardState extends State<ProductCard> {
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
    }catch(error){
      GlobalMethods().alertDialog(message: '$error', ctx: context, image: 'images/close.png');
    }
  }
  void _deleteProduct()async{
  try{
    await FireStoreServices().deleteProduct(widget.productId,widget.images);

  }catch(error){
    print(error);
  }
 }

 @override
  void initState() {
     _getSavedList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Timestamp postedDateTimeStamp = widget.date;
    var postDate = postedDateTimeStamp.toDate();
   String _postedDate = '${postDate.year}/${postDate.month}/${postDate.day}';
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(productId: widget.productId,sellerId: widget.sellerId,)));

      },
      child: Stack(
        children: [
          Container(
            width: screenWidth*4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),

               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.shade300,
                 )
               ]
            ),
            child: Column(
              children: [
                Container(
                  width: screenWidth*4,
                  height: screenHeight*0.16,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                      color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.fill
                    )
                  ),
                ),
                Container(
                  width: screenWidth*4,
                  height: screenHeight*0.05,
                 padding: EdgeInsets.symmetric(horizontal: 5.0),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                     bottomRight: Radius.circular(5),
                     bottomLeft: Radius.circular(5),
                   ),
                 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(widget.title,style: TextStyle(fontSize: 16.0),),
                        AutoSizeText('${widget.price}DA',style: TextStyle(fontSize: 16.0),)

                      ],
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,

                       children: [
                         GestureDetector(
                           onTap:(){
                             setState(() {
                               isSaved = !isSaved;
                             });
                             _savedUnsavedProduct();
                           },
                         child:Icon(iconData,color:Colors.orange,),

                         ),
                         AutoSizeText(_postedDate,style: TextStyle(fontSize: 5.0,color: Colors.grey[600]),)

                       ],
                     )
                   ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 2,
              right: 2,
              child:widget.sellerId == userId?InkWell(
                onTap: (){
                 _delete();
                },
                child: Icon(Icons.delete_forever,color: Colors.red,),
              ):Container(height: 0.0,width: 0.0,))
        ],
      ),
    );
  }

  void _delete() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text(
              'are you sure you want delete ?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteProduct();
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "Product Deleted ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }

}
