import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_cancel.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_successful.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardPaymentPage extends StatefulWidget {
  final String webUrl;
  final String orderId;
  final String sessionId;
  const CardPaymentPage({Key key, this.webUrl, this.orderId, this.sessionId})
      : super(key: key);

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  String orderId;
  String sessionId;
  bool isApiCallProcess = true;
  @override
  Widget build(BuildContext context) {
    orderId = widget.orderId;
    sessionId = widget.sessionId;
    Uri uri =
        Uri(scheme: 'https', path: '/index.jsp', host: 'mpi.quipugmbh.com',
            // port: 9601,
            queryParameters: {'ORDERID': orderId, 'SESSIONID': sessionId});

    print(uri.toString());

    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Card Payment',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: WebView(
            initialUrl: uri.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (request) {
              print(request);
              return _buildNavigationDecision(request);
            },
            navigationDelegate: (request) {
              print(request);
              return _buildNavigationDecision(request);
            },
            onPageFinished: (url) {
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
    print('request state');
    if (request.contains(Config.baseUrl + '/cancel/')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentCancel(
                  orderId: widget.orderId,
                )),
        ModalRoute.withName('/homeScreen'),
      );
      return NavigationDecision.prevent;
    } else if (request.contains(Config.baseUrl + '/payment-successful/')) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessful(
            orderId: widget.orderId,
          ),
        ),
        ModalRoute.withName('/homeScreen'),
      );
      return NavigationDecision.prevent;
    }
    return NavigationDecision.prevent;
  }
}
