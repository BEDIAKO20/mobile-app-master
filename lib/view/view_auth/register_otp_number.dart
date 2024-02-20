import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/provider/payment_provider.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/order/order_summary.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

// import 'package:telephony/telephony.dart';
import 'dart:io' show Platform;

enum NumberVerificationState {
  SHOW_REGISTER_FORM_STATE,
  SHOW_OTP_VERIFY_FORM_STATE,
  SHOW_LOADING_STATE
}

class Register extends StatefulWidget {
  const Register(
      {Key key, this.address, this.city, this.model, this.paymentType})
      : super(key: key);

  final address;
  final city;
  final Billing model;
  final String paymentType;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // String _code = "";
  // String appSignature = "";

  // OTPTextEditController controller;
  // OTPInteractor _otpInteractor;

  NumberVerificationState currentState =
      NumberVerificationState.SHOW_REGISTER_FORM_STATE;
  String _phoneNumber;
  String _otpNumber;
  String verificationID;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'GH';
  PhoneNumber number = PhoneNumber(isoCode: 'GH');
  FirebaseAuth _auth = FirebaseAuth.instance;
  PaymentProvider paymentProvider;

  bool isApiCallProcess = false;

  // Telephony telephony = Telephony.instance;
  OtpFieldController otpbox = OtpFieldController();

  @override
  void initState() {
    // TODO: implement initState

    // if (Platform.isAndroid) {
    //   telephony.listenIncomingSms(
    //     onNewMessage: (SmsMessage message) {
    //       print(message.address);
    //       print("adress on top"); //+977981******67, sender nubmer
    //       print(message.body); //Your OTP code is 34567
    //       print(message.date); //1659690242000, timestamp

    //       String sms = message.body.toString(); //get the message

    //       if (message.address == 'CloudOTP') {
    //         //verify SMS is sent for OTP with sender number
    //         String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
    //         //prase code from the OTP sms
    //         otpbox.set(otpcode.split(""));
    //         //split otp code to list of number
    //         //and populate to otb boxes

    //         // print("otp value");
    //         // print(otpcode);

    //         if (otpcode.isNotEmpty) {
    //           setState(() {
    //             //refresh UI

    //             _otpNumber = otpcode;
    //           });
    //         }
    //       } else {
    //         print("Normal message.");
    //       }
    //     },
    //     listenInBackground: false,
    //   );
    // }

    super.initState();

    //  listenForCode();
    // SmsAutoFill().listenForCode();

    // SmsAutoFill().getAppSignature.then((signature) {
    //   setState(() {
    //     appSignature = signature;
    //   });
    // });

    // print("appSignature");
    // print(appSignature);
    // });

    // _otpInteractor = OTPInteractor();
    // _otpInteractor
    //     .getAppSignature()
    //     //ignore: avoid_print
    //     .then((value) => print('signature - $value'));

    // controller = OTPTextEditController(
    //   codeLength: 5,
    //   //ignore: avoid_print
    //   onCodeReceive: (code) => print('Your Application receive code - $code'),
    //   otpInteractor: _otpInteractor,
    // )..startListenUserConsent(
    //     (code) {
    //       final exp = RegExp(r'(\d{5})');
    //       return exp.stringMatch(code ?? '') ?? '';
    //     },
    //     // strategies: [
    //     //   // SampleStrategy(),
    //     // ],
    //   );
  }

  // @override
  // Future<void> dispose() async {
  //   await controller.stopListen();
  //   super.dispose();
  // }

  // @override
  // void dispose() {
  //   // SmsAutoFill().unregisterListener();
  //   controller?.dispose();

  //   super.dispose();
  // }

  void signInWithPhoneAuthCredentials(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isApiCallProcess = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        isApiCallProcess = false;
      });
      if (authCredential?.user != null) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => OrderPayPage(
        //       model: widget.model,
        //     ),
        //   ),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSummaryPage(
              address: widget.address,
              city: widget.city,
              model: widget.model,
              paymentType: widget.paymentType,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget build(BuildContext context) {
    print("otp value widget");
    print(_otpNumber);
    paymentProvider = Provider.of<PaymentProvider>(context);
    return currentState == NumberVerificationState.SHOW_REGISTER_FORM_STATE
        ? register(context)
        : verifyPage(context);
  }

  Widget register(context) {
    print("otp box");
    print(otpbox);
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff7f6fb),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/illustration-2.png',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Add your phone number. we'll send you a verification code.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    //print(number.phoneNumber);
                                    setState(() {
                                      _phoneNumber = number.phoneNumber;
                                    });
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: Colors.black),
                                  initialValue: number,
                                  textFieldController: controller,
                                  formatInput: false,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputBorder: OutlineInputBorder(),
                                  onSaved: (PhoneNumber number) {
                                    print('On Saved: $number');
                                    _phoneNumber = number.phoneNumber;
                                    print(_phoneNumber);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        formKey.currentState.validate();
                                        setState(() {
                                          isApiCallProcess = true;
                                        });
                                        print(_phoneNumber);

                                        _oTPverification();
                                        paymentProvider.saveOtpPhoneNumber(
                                            _phoneNumber.toString());
                                        await _auth.verifyPhoneNumber(
                                            phoneNumber: _phoneNumber,
                                            verificationCompleted:
                                                (phoneAuthCredential) async {
                                              //phoneAuthCredential.smsCode.toString()

                                              setState(() {
                                                isApiCallProcess = false;
                                              });

                                              print('verfication complete');
                                            },
                                            verificationFailed:
                                                (verificationFailed) async {
                                              setState(() {
                                                isApiCallProcess = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    verificationFailed.message),
                                                backgroundColor: Colors.red,
                                              ));
                                            },
                                            codeSent: (verificationId,
                                                reSendingToken) async {
                                              setState(() {
                                                isApiCallProcess = false;
                                                currentState =
                                                    NumberVerificationState
                                                        .SHOW_OTP_VERIFY_FORM_STATE;
                                                verificationID = verificationId;
                                              });
                                            },
                                            codeAutoRetrievalTimeout:
                                                (verificationId) async {
                                              print('otp timed out');
                                            });
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                secondaryColor),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Text(
                                          'Send',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget verifyPage(context) {
    return ProgressHUD(
      text: Text(
        "Verifying...",
        style: TextStyle(
            fontSize: 12, color: Colors.black, decoration: TextDecoration.none),
      ),
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        backgroundColor: Color(0xfff7f6fb),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/illustration-3.png',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your OTP code number",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:

                                  //     TextField(
                                  //   textAlign: TextAlign.center,
                                  //   keyboardType: TextInputType.number,
                                  //   controller: controller,
                                  // )

                                  //         PinFieldAutoFill(
                                  //   decoration: UnderlineDecoration(
                                  //     textStyle: TextStyle(
                                  //         fontSize: 20, color: Colors.black),
                                  //     colorBuilder: FixedColorBuilder(Colors.black),
                                  //   ),
                                  //   currentCode: _code,
                                  //   onCodeSubmitted: (pin) {
                                  //     print("Completed: " + pin);
                                  //     _otpNumber = pin;
                                  //     setState(() {
                                  //       _otpNumber = pin;
                                  //     });
                                  //   },
                                  //   onCodeChanged: (code) {
                                  //     if (code.length == 6) {
                                  //       FocusScope.of(context)
                                  //           .requestFocus(FocusNode());
                                  //     }
                                  //   },
                                  //   codeLength: 6,
                                  // )

                                  OTPTextField(
                                controller: otpbox,
                                onChanged: (value) {
                                  print("printed from onchanged");
                                  print(value);
                                  setState(() {
                                    _otpNumber = value;
                                  });
                                  // _otpNumber = _otpNumber;
                                },
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 40,
                                style: TextStyle(fontSize: 17),
                                //textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                outlineBorderRadius: 20,
                                onCompleted: (pin) {
                                  print("Completed: " + pin);
                                  // _otpNumber = pin;
                                  setState(() {
                                    _otpNumber = pin;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                print("Printing from verify button" +
                                    _otpNumber.substring(
                                        0, _otpNumber.length - 1));

                                PhoneAuthCredential phoneAuthCredential =
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationID,
                                        smsCode: _otpNumber.length ==7? _otpNumber.substring(
                                            0, _otpNumber.length - 1):_otpNumber);
                                signInWithPhoneAuthCredentials(
                                    phoneAuthCredential);
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        secondaryColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isApiCallProcess = true;
                      });
                      _oTPverification();
                    },
                    child: Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _oTPverification() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          //phoneAuthCredential.smsCode.toString()
          setState(() {
            isApiCallProcess = false;
          });

          print('verfication complete');
        },
        verificationFailed: (verificationFailed) async {
          setState(() {
            isApiCallProcess = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(verificationFailed.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        codeSent: (verificationId, reSendingToken) async {
          setState(() {
            isApiCallProcess = false;
            currentState = NumberVerificationState.SHOW_OTP_VERIFY_FORM_STATE;
            verificationID = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          print('otp failed');
        });
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }
}
