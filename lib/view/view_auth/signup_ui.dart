import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/customerModel.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/util/form_helper.dart';
import 'package:franko_mobile_app/view/view_auth/login_ui.dart';
import 'package:franko_mobile_app/view/widget/auth_background.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  APIService apiService;
  bool hidePassword = true;
  bool hidePasswordConfirm = true;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Customer model;
  String confirmPassword;
  bool isApiCallProcess = false;
  UserProvider userProvider;

  void initState() {
    super.initState();
    apiService = new APIService();
    model = new Customer();

  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _uiSetUp(context), inAsyncCall: isApiCallProcess);
  }

  Widget _uiSetUp(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    userProvider = Provider.of<UserProvider>(context);

    return Background(
        child: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        SvgPicture.asset(
          "assets/icons/login.svg",
          height: size.height * 0.3,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Firstname is required";
                    }
                    return null;
                  },
                  onSaved: (value) => model.firstName = value,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Firstname",
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lastname is required";
                    }
                    return null;
                  },
                  onSaved: (value) => {
                    model.lastName = value,
                    //provider method for storing in share prefs
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Lastname",
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
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email is required";
                    } else {
                      if (!_emailRegExp.hasMatch(value)) {
                        return "Invalid email address";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) => model.email = value,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.mail,
                      color: kPrimaryColor,
                    ),
                    hintText: "Email",
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  onSaved: (value) => model.password = value,
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
                width: size.width * 0.8,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(29)),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return "Confirm Password is required";

                    return null;
                  },
                  obscureText: hidePasswordConfirm,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      hintText: "Confirm Password",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePasswordConfirm = !hidePasswordConfirm;
                          });
                        },
                        color: kPrimaryColor.withOpacity(0.4),
                        icon: Icon(hidePasswordConfirm
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
                      onPressed: () async {
                        // //String token;
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        //    //await prefs.setString("token", "this is a value");
                        // String tokenValue =  prefs.getString("token");
                        // print(tokenValue);
                        if (validateAndSave(model)) {
                          // print(model);
                          //var customer = model.toJson();
                          setState(() {
                            isApiCallProcess = true;
                          });
                          apiService.createCustomer(model).then((value) {
                            print(value);
                            setState(() {
                              isApiCallProcess = false;
                            });
                            if (value) {
                              userProvider.saveUserDetails(model);
                              FormHelper.showMessage(
                                context,
                                "Franko Trading",
                                "User Registration Successful!, Please Login",
                                "Ok",
                                () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                      ModalRoute.withName("/Home"));
                                },
                              );
                            } else {
                              FormHelper.showMessage(
                                context,
                                "oops",
                                "An account with this email already exists",
                                "Ok",
                                () {
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          });
                        }
                      },
                      // padding:
                      //     EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      // color: kPrimaryColor,
                      style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40)),
                            foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                            backgroundColor:  MaterialStateProperty.all<Color>(kPrimaryColor),
                           ),
                      //onPressed: () {},
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do you have an existing account ?",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          " Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),)
            ],
          )),
        )
      ]),
    ));
  }

  bool validateAndSave(model) {
    final form = globalKey.currentState;
   
    
    if (form.validate()) {
      print(model.toString() + " sign up");

      form.save();
      return true;
    }
    return false;
  }
}


