import 'dart:convert';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/provider/payment_provider.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/order/order_summary.dart';
import 'package:franko_mobile_app/view/view_auth/register_otp_number.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:franko_mobile_app/models/loginModel.dart';

class VerifyAddress extends StatefulWidget {
  VerifyAddress({Key key}) : super(key: key);

  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends State<VerifyAddress> {
  final _formKey = GlobalKey<FormState>();
  String selectedRole = "Writer";

  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  APIService apiService;
  Billing model;
  TextEditingController _firstname;

  List<Cart> items;
  bool isApiCallProcess = false;
  String paymentType;

  DataU _tokenValue;
  CartManager cartProvider;
  UserProvider userProvider;
  Map userDetails = {};
  AnalyticsService analyticsService = AnalyticsService();

  @override
  void initState() {
    apiService = new APIService();
    model = new Billing();
    model.address2 = "";
    model.state = "";
    model.postcode = "";
    model.country = "";
    items = Provider.of<CartManager>(context, listen: false).incartItems;

    // Provider.of<UserProvider>(context, listen: false).loadUserDetails();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadUserDetails();

    super.initState();
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            String value = prefs.getString("token") ?? null;
            if (value != null) {
              var token = json.decode(value);
              _tokenValue = DataU.fromJson(token);

              //tokenValue = tokenValue2.toJson();
              //print(tokenValue2.toJson());
            }
          })
        });
    analyticsService.setCurrentScreen(
        'verify_address_screen', 'VerifyAddressScreen');
    _firstname = TextEditingController(
        text: _tokenValue != null ? _tokenValue.firstname : "");
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartManager>(context, listen: false);

    var data = userProvider.details;
    print(data);
    print('--data--');
    userDetails = data;

    // print(userProvider);
    // print('--verify--');

    return ProgressHUD(
      child: _stepper(),
      inAsyncCall: isApiCallProcess,
    );
  }

  Widget _stepper() {
    final List<CoolStep> steps = [
      CoolStep(
        title: "Delivery Address",
        subtitle: "Please fill in your basic information to place an order",
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                  labelText: "Firstname",
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Firstname is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    model.firstName = value.trim();
                  },
                  initialValue: userDetails['first_name'] ?? ""
                  //controller: _txtCtrl,
                  ),
              _buildTextField(
                  labelText: "Lastname",
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lastname is required";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    model.lastName = value.trim();
                  },
                  initialValue: userDetails['last_name'] ?? ""
                  //controller: _txtCtrl,
                  ),
              _buildTextField(
                labelText: "Address",
                icon: Icon(
                  Icons.home,
                  color: kPrimaryColor,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Your Address is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  model.address1 = value.trim();
                },
                //controller: _txtCtrl,
              ),
              _buildTextField(
                readOnly:true,
                labelText: "City",
                icon: Icon(
                  Icons.location_city_outlined,
                  color: kPrimaryColor,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "City is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  model.city = value.trim();
                },
                initialValue: cartProvider.shippingAddressLocation,
                //controller: _txtCtrl,
              ),
              _buildTextField(
                  labelText: "Email",
                  icon: Icon(
                    Icons.email,
                    color: kPrimaryColor,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email is required";
                    } else {
                      if (!_emailRegExp.hasMatch(value)) {
                        return "Please provide a valid email address";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    model.email = value.trim();
                  },
                  initialValue: userDetails['email']
                  //controller: _emailCtrl,
                  ),
              _buildTextField(
                isNumber: true,
                labelText: "Phone Number",
                icon: Icon(
                  Icons.phone,
                  color: kPrimaryColor,
                ),
                validator: (value) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = new RegExp(pattern);
                  if (value.length == 0) {
                    return 'Please enter mobile number';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  model.phone = value.trim();
                },
                //controller: _txtCtrl,
              ),
            ],
          ),
        ),
        validation: () {
          if (!_formKey.currentState.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Fill the form correctly'),
              backgroundColor: Colors.red,
            ));
            return "Fill form correctly";
          }
          _formKey.currentState.save();
          return null;
        },
      ),
      //
      CoolStep(
        title: "Payment Options",
        subtitle: "Choose Payment Option",
        content: Container(
          child: Column(
            children: [
              // Row(
              //   children: <Widget>[
              //     _buildSelector(
              //       context: context,
              //       name: "Mobile Money",
              //       subtitle: Text('Pay with MTN, Vodaphone and Airteltigo'),
              //       secondary: Image.asset(
              //         'assets/images/banner_mobile_money.png',
              //         height: 30,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                children: <Widget>[
                  _buildSelector(
                      context: context,
                      name: "Online Payment",
                      subtitle: Text('Pay with Visa or Mastercard'),
                      secondary: Padding(
                        child: Image.asset(
                          'assets/images/fidelity.png',
                          //height: 20,
                          //alignment: Alignment.bottomCenter,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  _buildSelector(
                      context: context,
                      name: "Cash on Delivery",
                      subtitle: Text('Pay Cash on delivery'),
                      secondary: Padding(
                        child: Image.asset(
                          'assets/images/cash.png',
                          height: 40,
                          //width: 100,
                          alignment: Alignment.bottomCenter,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                      )),
                ],
              )
            ],
          ),
        ),
        validation: () {
          return null;
        },
      ),
    ];

    final stepper = CoolStepper(
      onCompleted: () {
        //print(model.toJson());
        // _placeOrder();

        if (Provider.of<PaymentProvider>(context, listen: false).paymentType ==
            'Online Payment') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Register(
                    address: model.address1,
                    city: model.city,
                    model: model,
                    paymentType: paymentType,
                  )));
        } else if (Provider.of<PaymentProvider>(context, listen: false)
                .paymentType ==
            "Mobile Money") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OrderSummaryPage(
                    address: model.address1,
                    city: model.city,
                    model: model,
                    paymentType: paymentType,
                  )));
        } else if (Provider.of<PaymentProvider>(context, listen: false)
                .paymentType ==
            "Cash on Delivery") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => OrderSummaryPage(
                    address: model.address1,
                    city: model.city,
                    model: model,
                    paymentType: paymentType,
                  )));
        }
      },
      steps: steps,
      config: CoolStepperConfig(
          backText: "PREV",
          stepText: "",
          finalText: "NEXT",
          headerColor: kPrimaryLightColor,
          titleTextStyle:
              TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
    );

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.green[50],
        child: stepper,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      automaticallyImplyLeading: true,
      title: Text(
        "Checkout",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildTextField({
    bool readOnly=false,
    bool isNumber = false,
    String labelText,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    Function(String) onSaved,
    Widget icon,
    String initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        //margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: kPrimaryLightColor, borderRadius: BorderRadius.circular(29)),
        child: TextFormField(
          readOnly:readOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            icon: icon,
          ),
          initialValue: initialValue,
          validator: validator,
          controller: controller,
          onSaved: onSaved,
        ),
      ),
    );
  }

  Widget _buildSelector({
    BuildContext context,
    String name,
    Widget secondary,
    Widget subtitle,
  }) {
    bool isActive = name == selectedRole;
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          //color: isActive ? Theme.of(context).primaryColor : null,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: RadioListTile(
          controlAffinity: ListTileControlAffinity.trailing,
          value: name,
          secondary: secondary,
          activeColor: kPrimaryColor,
          groupValue: selectedRole,
          onChanged: (String v) {
            
            setState(() {
              selectedRole = v;
              paymentType = v;
              Provider.of<PaymentProvider>(context, listen: false)
                  .selectpaymentType(v);
              print(paymentType);
            });
          },
          title: Text(
            name,
            style: TextStyle(
              color: isActive ? kPrimaryColor : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: subtitle,
        ),
      ),
    );
  }
}
