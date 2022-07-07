import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textValueController;
  final String? valueKey;
  final Function? onValidate;
  final Function? onEditComplete;
  final Function? onSave;
  final String? hint;
  final FocusNode? node;
  final TextInputType? textInputType;
  final Icon? icon;
  final String? initialValue;
  final IconData? suffixIcon ;
  final Function? onSuffixTap;
  final String? labelText;
  CustomTextField(
      {this.textValueController,
        this.textInputType,
        this.onSuffixTap,
        this.initialValue,
        this.labelText,
       this.suffixIcon,
        this.onEditComplete,
      this.onValidate,
      this.onSave,
      this.valueKey,
      this.icon,
      this.hint,
      this.node});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black),

      controller: textValueController,
       initialValue: initialValue,
       key: ValueKey(valueKey),
        validator: onValidate as String? Function(String?)?,
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditComplete as void Function()?,
         keyboardType: textInputType,
         decoration: InputDecoration(
           focusColor: Colors.black,
          enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff292d32),
                width: 1
            ),

            borderRadius: BorderRadius.circular(10.0),

          ),
             border:OutlineInputBorder(
               borderSide: BorderSide(
                   color: Color(0xff292d32),
                   width: 1
               ),
               borderRadius: BorderRadius.circular(10.0),

             ) ,
          errorBorder:OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red,
                width: 1
            ),
            borderRadius: BorderRadius.circular(10.0),

          ),
          focusedBorder:OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff292d32),
                width: 1
            ),
            borderRadius: BorderRadius.circular(10.0),

          ),
          labelText: labelText,
           labelStyle: TextStyle(color: Colors.black),
           hintStyle: TextStyle(color: Colors.grey),

            fillColor: Colors.white30,
            filled: true,
            prefixIcon: icon,
            suffixIcon: IconButton(
              onPressed: onSuffixTap as void Function()?,
              icon: Icon(suffixIcon,color:Colors.grey,),
            ),

            //
            hintText: hint),
             );
  }
}
