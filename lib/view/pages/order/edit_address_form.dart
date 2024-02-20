import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/address_model.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:hive/hive.dart';

import 'address_management.dart';

class EditAddressForm extends StatefulWidget {
  const EditAddressForm({ Key key,this.address }) : super(key: key);
  final Address address;

  @override
  State<EditAddressForm> createState() => _EditAddressFormState();
}

class _EditAddressFormState extends State<EditAddressForm> {
   final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final _formKey = GlobalKey<FormState>();
  CartManager cartProvider;
  UserProvider userProvider;
  Map userDetails = {};
  Billing model;
  List<Cart> items;

   @override
  void dispose() {
    // TODO: implement dispose

    Hive.box('address').close();
    super.dispose();
  }

  //  Billing  model = new Billing();

  @override
  void initState() {
    // apiService = new APIService();
    model = new Billing();
    model.address2 = "";
    model.state = "";
    model.postcode = "";
    model.country = "";
    

    super.initState();
  
  }

  
  @override
  Widget build(BuildContext context) {
     var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Address Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(
                  height: 20,
                ),
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
                    print("address 1");
                    print(model.address1);
                  },
                  initialValue: widget.address.firstName ?? ""
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
                    print("lastname");
                    print(model.lastName);
                  },
                  initialValue: widget.address.lastName ?? ""
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
                    print(model.address1);
                  },
                  //controller: _txtCtrl,
                  initialValue: widget.address.city??""
                ),
                _buildTextField(
                  // readOnly: true,
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
                    print(model.city);
                  },
                  initialValue: widget.address.city??"",
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
                    initialValue: widget.address.email??""
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
                    print("phone");
                    print(model.phone);
                  },
                  initialValue:widget.address.phoneNumber??""
                  //controller: _txtCtrl,
                ),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextButton.icon(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green[100]),
                      onPressed: () async {
                        // if (!_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        // print("First name for address");
                        // print(model.firstName);
                        await editAddressTransaction(
                            widget.address,
                            model.firstName,
                            model.lastName,
                            model.city,
                            model.email,
                            model.phone);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddressManagementPage()));

                        // }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child:
                            Text("Add", style: TextStyle(color: Colors.green)),
                      )),
                )
              ],
            ),
          )),
    );
  }

  Future<void> editAddressTransaction(Address address, String firstName,
    String lastName, String city, String email, String phoneNumber) async {
  address.firstName = firstName;
  address.lastName = lastName;
  address.city = city;
  address.email = email;
  address.phoneNumber = phoneNumber;

  address.save();
}



 Widget _buildTextField({
    bool readOnly = false,
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
          readOnly: readOnly,
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

}