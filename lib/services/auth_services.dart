import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' ;

class AuthService {
final  FirebaseAuth auth = FirebaseAuth.instance;
  Future createAccount (String email, String password)async{
  await auth.createUserWithEmailAndPassword(email: email, password: password);

  }
  Future singIn (String email, String password)async{
    await auth.signInWithEmailAndPassword(email: email, password: password);

  }
  Future singOut()async{
    await auth.signOut();
  }

  Future saveInfo (
      {String? email,
      String? userId,
      String? userName,
      String? phone,
      String? imageUrl,
      String? location}
      )async{

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
       'id':userId,
       'name':userName,
       'email':email,
       'phone' : phone,
       'location':location,
       'date': Timestamp.now(),
       'image':imageUrl,
      'savedProducts':[],
     });
  }
  Future<String> uploadImage({String? userId, File? file})async{
    final ref = FirebaseStorage.instance.ref().child('users_images').child('$userId.jpg');
    await ref.putFile(file!);
    String url =await ref.getDownloadURL();
    print(url);
    return url;
  }}