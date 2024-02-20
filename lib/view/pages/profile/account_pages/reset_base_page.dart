import 'package:flutter/material.dart';

class ResetBasePage extends StatefulWidget {
  ResetBasePage({Key key, this.title}) : super(key: key);

 final String title;

  @override
  ResetBasePageState createState() => ResetBasePageState();
}

class ResetBasePageState<T extends ResetBasePage> extends State<T> {
  
 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: _buildAppBar(this.widget.title != null ? this.widget.title : "Franko Trading"),
        body: Container(
          child: pageUI(context),
        ),
      );
  }

  Widget pageUI(BuildContext context) {
    return null;
  }

  Widget _buildAppBar(title) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      automaticallyImplyLeading: false,
      title: Text(title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  
}
