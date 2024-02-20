import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/util/form_helper.dart';
import 'package:franko_mobile_app/view/view_auth/password_reset.dart';
import 'package:franko_mobile_app/view/view_auth/signup_ui.dart';
import 'package:franko_mobile_app/view/widget/auth_background.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.value}) : super(key: key);

  final String value;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  APIService apiService;
  AnalyticsService analyticsService = AnalyticsService();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String username;
  String password;
  UserProvider userProvider;
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: _uiSetUp(),
        inAsyncCall: isApiCallProcess,
        text: Text(
          'Loading...',
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              decoration: TextDecoration.none),
        ));
  }
  // Future<void> _userType() async {
  //   await widget.analytics.setUserProperty(name: 'Dynamo', value: 'Developer');
  // }

  Widget _uiSetUp() {
    Size size = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context);

    return Background(
        child: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        SvgPicture.asset(
          "assets/icons/franko.svg",
          height: size.height * 0.35,
          width: 10,
        ),
        Form(
          key: globalKey,
          child: Container(
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
                  onSaved: (input) => username = input,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Your Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: size.width * 0.8,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(29)),
                child: TextFormField(
                  // keyboardType: TextInputType.visiblePassword,

                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  onSaved: (input) => password = input,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      hintText: "Password",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        color: kPrimaryColor.withOpacity(0.4),
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.8,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: TextButton(
                      // padding:
                      //     EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      // color: kPrimaryColor,
                      style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                           ),
                      onPressed: () {
                        if (validateAndSave()) {
                          print(username);
                          print(password);
                          setState(() {
                            isApiCallProcess = true;
                          });
                          apiService
                              .loginCustomer(username, password)
                              .then((value) => {
                                    setState(() {
                                      isApiCallProcess = false;
                                    }),
                                    if (value.success != false)
                                      {
                                        //userProvider.saveUserDetails(value),
                                        print('login apiservice  --login'),
                                        print(value.data),
                                        print(value.success),
                                        print('login response'),
                                        FormHelper.showMessage(
                                            context,
                                            "Franko",
                                            "You've Login Successfully ${value.data.firstname}",
                                            "ok", () {
                                          if (this.widget.value == "account") {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/account',
                                              ModalRoute.withName(
                                                '/homeScreen',
                                              ),
                                            );
                                            // Navigator.pop(context);
                                          } else {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/cart',
                                                ModalRoute.withName(
                                                    '/homeScreen'));
                                                    // Navigator.pop(context);
                                          }
                                        })
                                      }
                                    else
                                      {
                                        print(value),
                                        FormHelper.showMessage(
                                            context,
                                            "${value.code}",
                                            "${value.message}",
                                            "ok", () {
                                          Navigator.of(context).pop();
                                        })
                                      }
                                  });
                        } else if (!validateAndSave()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Incorrect login details'),
                          ));
                          return "";
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't you have an Account ?",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        " Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordReset(
                                title: "Reset Password",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        )
      ]),
    ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    print("Form not saved");
    return false;
  }
}
