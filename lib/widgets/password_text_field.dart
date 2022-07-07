import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? textValueController;
  final String? valueKey;
  final Function? onEditComplete;
  final String? hint;
  final Function? onValidate;
  final FocusNode? node;
  final String? labelText;

  PasswordTextField(
      {this.textValueController,
        this.labelText,
        this.hint,
        this.onEditComplete,
        this.onValidate,
        this.valueKey,
        this.node});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      style: TextStyle(color: Colors.black),
      key: ValueKey(widget.valueKey),
      controller: widget.textValueController ,
      focusNode: widget.node,
      validator: widget.onValidate as String? Function(String?)?,
      textInputAction: TextInputAction.next,
      onEditingComplete: widget.onEditComplete as void Function()?,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(

        labelText: widget.labelText,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle:TextStyle(color: Colors.black) ,
        enabledBorder:OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black,
              width: 1
          ),
          borderRadius: BorderRadius.circular(10.0),

        ),
        errorBorder:OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red,
              width: 1
          ),
          borderRadius: BorderRadius.circular(10.0),

        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1
          ),
          borderRadius: BorderRadius.circular(10.0),

        ),
          border:OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black,
                width: 1
            ),
            borderRadius: BorderRadius.circular(10.0),

          ) ,

          fillColor: Colors.white30,
          filled: true,
          prefixIcon: Icon(Icons.lock,color: Color(0xff292d32),),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(_obscureText
                ? Icons.visibility
                : Icons.visibility_off,color:Colors.deepOrange,),
          ),


          hintText: widget.hint,

      ),
      obscureText: _obscureText,

    );
  }
}
