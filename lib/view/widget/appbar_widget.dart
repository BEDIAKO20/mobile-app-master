import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget {
  AppBarWidget({Key key,}) : super(key: key);

  

  

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      automaticallyImplyLeading: true,
      title: Text(
        "Franko Trading",
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search), onPressed: () {}, color: Colors.black),
        IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Colors.black),
      ],
    );
  }
}