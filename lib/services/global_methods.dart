import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMethods{
  Position? _currentPosition ;

  void openWhatsapp(String phoneNumber , String message)async{
    var url = 'https://wa.me/$phoneNumber?/text=$message';

    if(await canLaunch(url)){
      await launch(url);
    }else{
      print('error');
      throw 'error occured';
    }
  }
  void openEmail(String email)async{
    var url = 'mailto:$email';

    if(await canLaunch(url)){
      await launch(url);
    }else{
      print('error');
      throw 'error occured';
    }
  }
  void makeCall(String phoneNumber)async{
    var url = 'tel://$phoneNumber';

    if(await canLaunch(url)){
      await launch(url);
    }else{
      print('error');
      throw 'error occured';
    }
  }
  getCurrentLocation()async {
    String? finalAddress ;
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async{
      _currentPosition = position;
      final coordinates = new Coordinates(_currentPosition!.latitude,_currentPosition!.longitude);
      var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      Address first = address.first;

      finalAddress = '${first.addressLine}';

    }).catchError((e) {
      print(e);
    });
    return finalAddress;
  }
  void launchMapsUrl(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
   void alertDialog(
      {required String message,String? action,Function? onAction ,String? submit,required BuildContext ctx,required String image,}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    '$image',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  Text(
                    action!
                  ),
                ),
              ],
            ),
            content: Text(
              '$message',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context) ;
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed:()=>onAction!,

                child: Text(
                  '$submit',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
  toast({required String message}){
    return  Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}