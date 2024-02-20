import 'package:flutter/material.dart';


class PaymentProvider with ChangeNotifier {
  String _paymentType;
  String get paymentType => _paymentType;

  bool _otpVerified;
  bool get otpVerified => _otpVerified;

  String _otpPhoneNumber;
  String get otpPhoneNumber => _otpPhoneNumber;

  PaymentProvider();

  changeOtpState() {
    _otpVerified != _otpVerified;
    notifyListeners();
  }

  

  selectpaymentType(String payType) {
    _paymentType = payType;
    print(_paymentType + "from payment provider");
    notifyListeners();
  }

  saveOtpPhoneNumber(String phoneNumber) {
    print('otp method called');
    _otpPhoneNumber = phoneNumber;
    print("printing otp phone" + phoneNumber);
    notifyListeners();
  }
}
