import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_cancel.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_successful.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../config.dart';

class CellulantPaymentPage extends StatefulWidget {
  final String webUrl;
  final String orderId;
  final String sessionId;
  final String email;
  final amount;
  final String customerPhoneNumber;
  final String first;
  final String last;

  const CellulantPaymentPage({
    Key key,
    this.webUrl,
    this.orderId,
    this.sessionId,
    this.amount,
    this.email,
    this.customerPhoneNumber,
    this.first,
    this.last,
  }) : super(key: key);

  @override
  _CellulantPaymentPageState createState() => _CellulantPaymentPageState();
}

class _CellulantPaymentPageState extends State<CellulantPaymentPage> {
  String orderId;
  String sessionId;
  bool isApiCallProcess = true;
  var encrpytedData;
  Uri cellUri;
  String liveAcceskey =
      "MKDHDAKRfHDiAiDRFvFZMMDRADFDKKFZfZKDHDfRMRiDFHHHHDvEDMRfDAZv";
  var uuid = Uuid();

  generateEncrptedData() async {
    String dueDate = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.now().add(Duration(minutes: 10)));
    print('duedate');
    print(dueDate);
    var transactionId = uuid.v4();
    print(transactionId);
    print(widget.first);
    encrpytedData = await encrypt(
        transactionId.toString(),
        widget.first,
        widget.last,
        widget.email,
        widget.customerPhoneNumber,
        widget.amount,
        dueDate);
    print('cellulant page');

    print(encrpytedData);

    print('encrypted data--- ${encrpytedData.toString()}');
    Uri uri = Uri(
        scheme: 'https',
        path: '/express/checkout',
        host: 'checkout.tingg.africa',
        // port: 9601,
        queryParameters: {
          'encrypted_payload': encrpytedData,
          //'',
          //encrpytedData,
          'access_key':
              'MKDHDAKRfHDiAiDRFvFZMMDRADFDKKFZfZKDHDfRMRiDFHHHHDvEDMRfDAZv'

          //'CDDSvSvn24D4dS44sysdCCqSqyvDydvqMZn44qvsZ4ZdVvCy2qVqDsqVSSyy'
        });

    setState(() {
      cellUri = uri;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateEncrptedData();
  }

  @override
  Widget build(BuildContext context) {
    orderId = widget.orderId;
    sessionId = widget.sessionId;
    print("cell uri");
    log(cellUri.toString());

    // Uri uri = Uri(
    //     scheme: 'https',
    //     path: '/index.jsp',
    //     host: 'mpi.quipugmbh.com',
    //     // port: 9601,
    //     queryParameters: {'ORDERID': orderId, 'SESSIONID': sessionId});

    // print(uri.toString());

    if (cellUri != null) {
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
              'Online Payment',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Container(
            child: WebView(
              initialUrl: cellUri.toString(),
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
    return Scaffold(
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
        body: Center(child: CircularProgressIndicator()));
  }

  NavigationDecision _buildNavigationDecision(request) {
    print("cancelled request");
    print(request);
    if (request.contains(
        "https://online.tingg.africa/v2/receipt/?paymentStatus=cancelled")) {
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
      print("successful request");
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
