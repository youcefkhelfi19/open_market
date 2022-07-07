import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final Function? onTap;
   final String? image ;
   final String? title ;
   final Color? buttonColor;
   final Color? textColor;
    CustomButton({this.textColor,this.buttonColor,this.onTap,this.title,this.image});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical:screenHeight*0.01),
        height: screenHeight*0.07,
        width: screenWidth*0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          boxShadow:[
            BoxShadow(

          ),],
          color: buttonColor
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: buttonColor,
            radius:screenHeight*0.035,
            child: Container(
              padding: EdgeInsets.all(10.0),

             child: Image.asset(image!),
            ),

          ),
          SizedBox(width: screenWidth*0.03,),
          AutoSizeText(title!,style: TextStyle(color: textColor,fontSize: 16.0),)
          ],
        ),
      ),
    );
  }
}
