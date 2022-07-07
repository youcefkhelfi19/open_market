import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({Key? key,required this.onTap,required this.icon,required this.title}) : super(key: key);
   final Function onTap;
   final String title ;
   final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTap();
      },
      leading: Icon(icon,color: Colors.black,),
      title:Text(title ,style: TextStyle(color: Colors.black ,fontSize: 16.0),) ,
    );
  }
}
