import 'package:flutter/material.dart';
import 'package:open_market/widgets/custom_drawer.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:CustomDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff292d32)),
        backgroundColor: Colors.orange,
        elevation: 0.0,
        title: Text(
          'Search',
          style: TextStyle(color: Color(0xff292d32)),
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(
                Icons.message_outlined,
                color: Color(0xff292d32),
              ))
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Search here',
                fillColor: Colors.white,
                focusColor: Colors.black,
                border: InputBorder.none,

                filled: true,
                suffixIcon: GestureDetector(
                  onTap: (){

                  },
                  child: Icon(Icons.search,color: Colors.black,),
                )
            ),
          ),
        ],
      ),
    );
  }
}
