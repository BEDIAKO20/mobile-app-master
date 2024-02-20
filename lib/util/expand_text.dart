import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ExpandText extends StatefulWidget {
  ExpandText({
    this.labelHeader,
    this.desc,
    //this.shortDesc,
  });

  String labelHeader;
  String desc;
  //String shortDesc;
  

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  //bool descTextShowFlag = false;


 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            this.widget.labelHeader,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        HtmlWidget(
             this.widget.desc, 
             textStyle: TextStyle(
               decoration: TextDecoration.none,
             ),
            ),
      ]
      
      ),
    );
  }
}


