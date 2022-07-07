import 'package:flutter/material.dart';
import 'package:open_market/screens/profile.dart';

class UserCard extends StatefulWidget {
    final String? userName;
    final String? imageUrl;
    final String? uid;

  const UserCard({Key? key, this.userName, this.imageUrl, this.uid}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
          onTap: () {
            print(widget.imageUrl!);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(userId: widget.uid!,)));

          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 1),
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: Image.network(widget.imageUrl!),
          ),),
          title: Text(
            widget.userName!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.linear_scale_outlined,
                color: Colors.pink.shade800,
              ),
              Text(
                'Position/6539494',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.mail_outline,
              size: 30,
              color: Colors.pink.shade800,
            ),
            onPressed: () {},
          )),
    );
  }
}
