import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget({Key? key, required this.color, required this.icon, required this.function}) : super(key: key);
  final Color color;
  final IconData icon ;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              function();
            },
          )),
    );
  }
}
