import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
              child: Container(
          color: Colors.white,
           width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset("assets/images/main_top.png", width: size.width * 0.35,),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset("assets/images/login_bottom.png", width: size.width * 0.4,),
              ),
              child,
            ]
          ),
        ),
      ),
    );
  }
}