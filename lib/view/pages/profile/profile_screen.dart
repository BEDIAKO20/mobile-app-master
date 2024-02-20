import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/body.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.loginValue, this.analytics, this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  String loginValue;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DataU tokenValue;

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            String value = prefs.getString("token") ?? null;
            if (value != null) {
              var token = json.decode(value);
              tokenValue = DataU.fromJson(token);
            }
          })
        });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _logOutMsg();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tokenValue != null
          ? AppBar(
              backgroundColor: kPrimaryColor,
              title: Text("Hello, ${tokenValue.firstname}"),
            )
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      body: Container(
        color: Colors.white,
        child: Body(),
      ),
    );
  }

  _logOutMsg() {
    double screenHeight = MediaQuery.of(context).size.height;
    if (this.widget.loginValue == "login") {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "You've Login sucessfully",
          style: TextStyle(color: Colors.white),
        ),
        margin:
            EdgeInsets.only(bottom: screenHeight * 0.85, right: 16, left: 16),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 3000),
        backgroundColor: kPrimaryColor,
        // animation:CurvedAnimation(parent: controller, curve: Curves.easeIn),
      ));
    } else {
      return;
    }
  }
}
