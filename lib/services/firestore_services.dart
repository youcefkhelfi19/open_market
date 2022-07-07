import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FireStoreServices{
  late firebase_storage.Reference ref;
   List<String> imagesLinks = [];
  List<dynamic> products = [];
  Future uploadProduct (
      {String? title,
        String? sellerId,
        String? productId,
        String? price,
        String? category,
        List? imagesLinks,
        List? comments,
        String? description})async{

    await FirebaseFirestore.instance.collection('products').doc(productId).set({
      'id':productId,
      'title':title,
      'seller': sellerId,
      'price':price,
      'category' : category,
      'date': Timestamp.now(),
      'image':imagesLinks,
      'description':description,
      'is_saved': false,
      'comments' : comments,
    });
  }
  Future<List<String>> uploadImage({List<File>? images,String? productId})async{
    for(var image in images!){
      final ref = FirebaseStorage.instance.ref().child('products').child(productId!).child('${Path.basename(image.path)}');
      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) => {
          imagesLinks.add(value),
         //print(value)
        });
      });
    }
    print(imagesLinks);
  return imagesLinks;
  }
  Future<void> deleteProduct(String productId,List images )async{
    for(String url in images){
      await FirebaseStorage.instance.refFromURL(url).delete();
    }
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();

  }

  Future saveProduct (
      {String? userId,
        String? productId,
        })async{

    await FirebaseFirestore.instance.collection('users').doc(userId).update(

        {'savedProducts': FieldValue.arrayUnion([
        productId
      ]),}
    );
  }
  Future unsavedProduct (
      {String? userId,
        String? productId,
      })async{

    await FirebaseFirestore.instance.collection('users').doc(userId).update(

        {'savedProducts': FieldValue.arrayRemove([
          productId
        ]),}
    );
  }
  Future<List<dynamic>> getSavedList(String userId)async{
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    if(documentSnapshot.data() != null){
      products = documentSnapshot.get('savedProducts');
      return  products;
    }else {
      return products;
    }
  }
}