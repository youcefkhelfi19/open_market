import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKit extends StatelessWidget {
  const SpinKit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      itemBuilder: (context,index){
        return CircleAvatar(
          radius: 70.0,
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
