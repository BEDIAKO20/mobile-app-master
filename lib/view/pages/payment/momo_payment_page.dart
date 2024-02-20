import 'dart:io';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_cancel.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_successful.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key, this.paymentUrl, this.id}) : super(key: key);

  final String paymentUrl;
  final String id;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool isApiCallProcess = true;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          child: WebView(
            initialUrl: widget.paymentUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (request) {
              print(request);
              return _buildNavigationDecision(request);
            },
            navigationDelegate: (request) {
              print(request);
              return _buildNavigationDecision(request);
            },
            onPageFinished: (request) {
              setState(() {
                isApiCallProcess = false;
              });
            },
          ),
        ),
      ),
    );
  }

  NavigationDecision _buildNavigationDecision(request) {
    print(request);
    if (request.contains(Config.baseUrl + '/cancel/')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PaymentCancel(orderId: widget.id,)),
        ModalRoute.withName('/homeScreen'),
      );
      return NavigationDecision.prevent;
    } else if (request
        .contains(Config.baseUrl + '/payment-successful/')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PaymentSuccessful(orderId: widget.id,)),
        ModalRoute.withName('/homeScreen'),
      );
      return NavigationDecision.prevent;
    }
    return NavigationDecision.prevent;
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
      centerTitle: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        "Mobile Money Payment",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}