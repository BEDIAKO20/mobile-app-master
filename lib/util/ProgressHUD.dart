
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/view/widget/const.dart';

class ProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;
  final Widget text;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.5,
    this.color = Colors.grey,
    this.valueColor,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          new Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          new Center(
            child: Container(
              height: 120,
              width: 120,
              color: Colors.black.withOpacity(0.3),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: new Center(
                        child: new CircularProgressIndicator(
                      backgroundColor: secondaryColor,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                        child: text ??
                            Text(
                              'Loading...',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            )),
                  ),
                ],
              ),
            ),
          )
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
