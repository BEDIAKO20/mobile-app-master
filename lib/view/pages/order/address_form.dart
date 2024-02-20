import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/address_model.dart';
import 'package:franko_mobile_app/models/cities.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/util/boxes.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({Key key}) : super(key: key);

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();

  CartManager cartProvider;
  UserProvider userProvider;
  Map userDetails = {};
  Billing model;
  List<Cart> items;

  List province = [];
  List myIds = [];
  String location;
  String charge;
  String regionValue;
  Cities cartDropdownData;
  String currencySymbol = 'GHS';

  List cities = [];
  List<Cities> towns = [];
  List<Cities> places = [];
  Map<String, dynamic> addressData;

  var dropdownvalue;
  var _category;
  List<String> newregions = [];
  bool cityState = false;

  CartManager cartData;

  CollectionReference _locations =
      FirebaseFirestore.instance.collection('Regions');

  getRegions() {
    // var reg = _locations.get();

    _locations.snapshots().map((event) {
      for (int i = 0; i < event.docs.length; i++) {
        DocumentSnapshot snap = event.docs[i];
        province.add(snap.id.toString());
      }

      setState(() {
        myIds = province;
      });
    }).toList();
  }

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
    items = Provider.of<CartManager>(context, listen: false).incartItems;

    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadUserDetails();
    getRegions();

    super.initState();
  }

  getCities(var dropdownvalue) async {
    setState(() {
      towns = [];
      places = [];
    });

    // dropdownvalue ?? 'Greater Accra';
    var docData = await _locations.doc(dropdownvalue).get();
    var data = docData.data();
    print("printing........");
    print(data);
    //print(docData);
    setState(() {
      final citiesData = data as Map;
      cities = citiesData['cities'];
    });

    cities.forEach((city) {
      // print(city);
      towns.add(Cities.fromJson(city));
    });
    setState(() {
      places = towns;
    });
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartManager>(context, listen: false);
    cartData = Provider.of<CartManager>(context, listen: false);

    var data = userProvider.details;
    print(data);
    // print('--data--');
    // userDetails = data;

    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Address Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(8),
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
                  if (value.isEmpty || value.length == 0 || value.length < 3) {
                    return "Firstname is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  model.firstName = value.trim();
                  // print("address 1");
                  // print(model.address1);
                },
                // initialValue: userDetails['first_name'] ?? ""
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
                  // print("lastname");
                  // print(model.lastName);
                },
                // initialValue: userDetails['last_name'] ?? ""
                //controller: _txtCtrl,
              ),

               
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectRegionMethod(screenWidth),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectCityMethod(screenWidth),
              ),
              _buildTextField(
                labelText: "Address   e.g Adabraka, Nkrumah Avenue",
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
                    print('value of email');
                    print(value);
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
               
              ),
              
              SizedBox(
                // height: 10,
                width: screenWidth * 0.7,
                child: TextButton(
                  // minWidth: screenWidth * 0.6,
                  // padding: EdgeInsets.all(10),
                  // color: secondaryColor,
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20)),

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      secondaryColor,
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(screenWidth * 0.6, 10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      // print("model email");
                      // print(model.email);
                      print("firstname");
                      print(model.firstName);
                      // print(regionValue);
                      // print(location);
                      await addAddressTransaction(
                          model.firstName,
                          model.lastName,
                          model.city,
                          model.email,
                          model.phone,
                          regionValue,
                          location,
                          cartProvider.shippingAddressFees);

                      Navigator.of(context).pop();

                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => AddressManagementPage()));
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container selectCityMethod(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      // color: Colors.white,
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  color: kPrimaryLightColor, //<-- SEE HERE
                ),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.all(6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                  ),

                  value: _category,
                  //elevation: 16,
                  icon: Icon(Icons.keyboard_arrow_down),
                  hint: Text(
                      '${cartData.shippingAddressLocation ?? 'Enter City'}'),
                  isDense: true,
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.black,
                  // ),
                  items: places.map<DropdownMenuItem<Cities>>((document) {
                        return DropdownMenuItem<Cities>(
                          onTap: () {
                            setState(() {
                              cartDropdownData = document;
                              //print(cartData.shippingAddressFees);
                              addressData = {
                                'Location': document.location,
                                'Charge': document.charge,
                                'Region': cartData.shippingAddressRegions
                              };
                              cartData.savedAddress();

                              charge = document.charge;
                            });
                            // print('---address details---');
                            // print(addressData);

                            location = document.location;
                            print("location new value");
                            print(document.location);
                            cartData.getShippingFee(addressData);

                            cartData.saveAddressDetails(addressData);
                          },
                          value: document,
                          child: Text(
                            document.location ?? '',
                            style: TextStyle(),
                          ),
                        );
                      }).toList() ??
                      [],
                  onChanged: (newValue) {
                    setState(() {
                      _category = newValue;

                      location = newValue;
                      print("location new value");
                      print(newValue);
                    });
                    // print('printing category');
                    // print(_category);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox selectRegionMethod(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          // margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: kPrimaryLightColor, //<-- SEE HERE
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                // fillColor: Colors.green,
                //contentPadding: EdgeInsets.all(6),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 1,
                    )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  borderSide: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                )),
            value: dropdownvalue ?? cartData.shippingAddressRegions,
            icon: Icon(Icons.keyboard_arrow_down),
            items: province.map((region) {
                  return DropdownMenuItem(
                    onTap: () {
                      setState(() {
                        regionValue = region;
                        cityState = false;
                      });
//                                             cartData
//                                                 .getShippingFee(addressData);

//                                             cartData.saveAddressDetails(
//                                                 addressData);

                      print('--regional value--');
                      print(regionValue);
                    },
                    value: region,
                    child: Text('$region'),
                  );
                }).toList() ??
                [],
            onChanged: (newValue) {
              setState(() {
                _category = null;
                dropdownvalue = newValue;
                cartData.saveRegionalvalue(regionValue);
                print("newValue");
                print(newValue);

                getCities(dropdownvalue);
              });
            },
            hint: Text('Select Region'),
            isExpanded: false,
          ),
        ),
      ),
    );
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

Future<void> addAddressTransaction(
    String firstName,
    String lastName,
    String city,
    String email,
    String phoneNumber,
    String regionValue,
    String towns,
    String price) {
  // print(' address T called');
  final addressTransaction = Address()
    ..firstName = firstName
    ..city = towns
    ..lastName = lastName
    ..email = email
    ..phoneNumber = phoneNumber
    ..region = regionValue
    ..towns = towns
    ..price = price;

  final box = Boxes.getAddressTransactions();
  box.add(addressTransaction);
}

Future editAddressTransaction(Address address, String firstName,
    String lastName, String city, String email, String phoneNumber) {
  address.firstName = firstName;
  address.lastName = lastName;
  address.city = city;
  address.email = email;
  address.phoneNumber = phoneNumber;

  address.save();
}
