import 'package:flutter/material.dart';
import 'package:open_market/models/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.category}) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              category.icon,
              size: 20.0,
              color: Colors.black,
            ),
            Text(
              category.title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}