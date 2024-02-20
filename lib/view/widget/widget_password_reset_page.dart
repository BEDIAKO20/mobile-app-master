import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/util/form_helper.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/reset_base_page.dart';
import 'package:franko_mobile_app/view/widget/const.dart';


class PasswordResetWidget extends ResetBasePage {
  PasswordResetWidget({Key key, this.title}) : super(key: key);

   String title = "Password Reset";

  @override
  _PasswordResetWidgetState createState() => _PasswordResetWidgetState();
}

class _PasswordResetWidgetState extends ResetBasePageState<PasswordResetWidget> {
  APIService _apiService;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isApiCallProcess = false;
  String email;

  @override
  void initState() {
    super.initState();
    _apiService = new APIService();
  }

  @override
  Widget pageUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: globalKey,
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29)),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email is required";
                        } else {
                          if (!_emailRegExp.hasMatch(value)) {
                            return "Please provide correct email address";
                          }
                        }
                        return null;
                      },
                      onSaved: (input) => email = input,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: kPrimaryColor,
                        ),
                        hintText: "Your Email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
                          // padding: EdgeInsets.symmetric(
                          //     vertical: 20, horizontal: 40),
                          // color: kPrimaryColor,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40)),
                            foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                           ),
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });
                              _apiService.passwordReset(email).then((value) => {
                                    setState(() {
                                      isApiCallProcess = false;
                                    }),
                                    if (value.message != null)
                                      {
                                        FormHelper.showMessage(
                                            context,
                                            "Franko Trading",
                                            "${value.message}",
                                            "ok", () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/validate',
                                                  ModalRoute.withName(
                                                      '/account'));
                                        })
                                      }
                                    else
                                      {
                                        FormHelper.showMessage(
                                            context,
                                            "Reset error",
                                            "No user found with this email address",
                                            "ok", () {
                                          Navigator.of(context).pop();
                                        })
                                      }
                                  });
                            } else if (!validateAndSave()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Please provide your email address')));
                              return "";
                            }
                          },
                          child: Text(
                            "RESET PASSWORD",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    // print("Form not saved");
    return false;
  }
}
