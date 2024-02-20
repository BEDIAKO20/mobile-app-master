import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.stepValue,
    @required this.iconSize,
    @required this.value,
    @required this.onChange,
    this.onIncrementChange,
    this.onDecrementChange,
  });

  final int lowerLimit;
  final int upperLimit;
  final int stepValue;
  final double iconSize;
  ValueChanged<dynamic> onIncrementChange;
  ValueChanged<dynamic> onDecrementChange;
  int value;
  final ValueChanged<dynamic> onChange;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      //margin: EdgeInsetsGeometry.lerp(a, b, t),
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white,
              blurRadius: 15,
              spreadRadius: 10,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(Icons.remove),
              iconSize: 25,
              onPressed: () {
                setState(() {
                  widget.value = widget.value == widget.lowerLimit
                      ? widget.lowerLimit
                      : widget.value -= widget.stepValue;
                  widget.onChange(widget.value);
                  widget.onDecrementChange(widget.value);
                });
              }),
          Container(
              width: this.widget.iconSize,
              child: Text(
                '${widget.value}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
          IconButton(
              icon: Icon(Icons.add),
              iconSize: 25,
              onPressed: () {
                setState(() {
                  widget.value = widget.value += widget.stepValue;
                  widget.onChange(widget.value);
                  widget.onIncrementChange(widget.onIncrementChange);
                });
              }),
        ],
      ),
    );
  }
}
