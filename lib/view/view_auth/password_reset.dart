
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/reset_base_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PasswordReset extends ResetBasePage {
  PasswordReset({Key key, this.title}) : super(key: key);

  String title = "Password Reset";

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends ResetBasePageState<PasswordReset> {
 

  bool isApiCallProcess = true;
  String email;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget pageUI(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: Container(
        child: WebView(
          initialUrl: Config.lostPasswordUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (request) {
            print(request);
            setState(() {
              isApiCallProcess = false;
            });
          },
          // navigationDelegate: (request) {
          //   print(request);
          // },
        ),
      ),
    );
  }
}
