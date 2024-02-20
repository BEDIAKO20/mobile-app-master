import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:franko_mobile_app/models/address_model.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/util/boxes.dart';
import 'package:franko_mobile_app/view/pages/order/address_form.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'order_pay.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({Key key}) : super(key: key);

  @override
  State<AddressManagementPage> createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  bool checkValue = false;
  CartManager cartProvider;
  Billing model;
  Address addressdata;

  String location = "";
  String fee = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    model = new Billing();
    model.address2 = "";
    model.state = "";
    model.postcode = "";
    model.country = "";

    Provider.of<CartManager>(context, listen: false).savedAddress();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartManager>(context, listen: true);
    location = cartProvider.persistedLocation;
    // fee = cartProvider.persistedFee;

    var dataBox = Boxes.getAddressTransactions();
    final addressTransactors = dataBox.values.toList().cast<Address>();

    addressTransactors.retainWhere((element) {
      return element.currentAddress == true;
    });

    print("address transactor city ");
    print(addressTransactors);
    if (addressTransactors.isNotEmpty) {
      print(addressTransactors[0].city);
      addressdata = addressTransactors[0];
      fee = addressTransactors[0].price;
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: secondaryColor,
        title: Text(
          "Shipping Address",
          style: TextStyle(color: Colors.white),
        ),
        
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddressFormPage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 32,),
                        // Text(
                        //   "Add",
                        //   style: TextStyle(color:addressTransactors.isEmpty?Colors.green: Colors.black, fontSize: 18),
                        // ),
                      ],
                    ),
                  )),
            ),
          )
        ],
        centerTitle: true,
        // backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ValueListenableBuilder<Box<Address>>(
          valueListenable: Boxes.getAddressTransactions().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Address>();

            if (transactions.isEmpty) {
              return Center(
                child: Text(
                  'No addresses yet!',
                  style: TextStyle(fontSize: 24),
                ),
              );
            }
//addressCardMethod(transactions),
            return Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.7,
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final transaction = transactions[index];

                      return addressCardMethod(
                          transaction, transactions, context);
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // height: 10,
                  width: screenWidth * 0.7,
                  child: TextButton(
                    // minWidth: screenWidth * 0.7,
                    // padding: EdgeInsets.all(10),
                    // color: addressTransactors.isEmpty
                    //     ? secondaryColor.withOpacity(0.2)
                    //     : secondaryColor,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20)),

                     style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            // minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.6,10)),
                            backgroundColor:  MaterialStateProperty.all<Color>(addressTransactors.isEmpty
                        ? secondaryColor.withOpacity(0.2)
                        : secondaryColor,),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                    onPressed: addressTransactors.isEmpty
                        ? () {}
                        : () {
                            model.address1 = addressdata.towns;
                            model.city = addressdata.city;
                            model.firstName = addressdata.firstName;
                            model.lastName = addressdata.lastName;
                            model.phone = addressdata.phoneNumber;
                            model.email = addressdata.email;

                            print('model.email');
                            print(model.email);
                            var data = json.encode(addressdata.toString());

                            var results = json.decode(data);

                            print(results);

                            Navigator.of(context).push(
                               MaterialPageRoute(
                                builder: (context) => OrderPayPage(model: model,),

                              )


                              // MaterialPageRoute(
                              //   builder: (context) => Register(
                              //     address: model.address1,
                              //     city: model.city,
                              //     model: model,
                              //     // paymentType: paymentType,
                              //   ),

                              // ),

                              
                            );

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => OrderPayPage(
                            //       model: model,
                            //     ),
                            //   ),
                            // );
                          },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: screenWidth * 0.7,
                //   child: TextButton(
                //     style: TextButton.styleFrom(
                //         backgroundColor: Colors.green[100]),
                //     onPressed: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => OrderPayPage()));
                //     },
                //     child: Text('Next', style: TextStyle(color: Colors.green)),
                //   ),
                // )
              ],
            );
          },
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          //height: 59.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Wrap(
                      //       children: [
                      //         //${cartProvider.shippingAddressLocation}'
                      //         Text(
                      //           'Location :$location',
                      //           style: TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Spacer(
                        flex: 1,
                      ),
                      fee != 'station'
                          ? Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                //${cartProvider.shippingAddressFees}
                                child: addressTransactors.isEmpty
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          'Delivery Price : GHS $fee',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ))
                          : Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                //${cartProvider.shippingAddressFees}
                                child: addressTransactors.isEmpty
                                    ? Container()
                                    : Center(
                                        child: Text(
                                          'Delivery to $fee',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              )),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(Address address, ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        double screenHeight = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: Text(
            'Remove Address',
            style: TextStyle(color: Colors.red),
          ),
          content: Row(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  "assets/icons/delete.svg",
                  height: 28,
                  //  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  'Do you want to delete this address?',
                ),
                flex: 3,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('deleted');
                Navigator.of(buildContext).pop();

                setState(() {
                  address.currentAddress = false;
                });

                //  Navigator.pop(ctx);

                address.delete();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Deleted sucessfully',
                    style: TextStyle(color: Colors.white),
                  ),

                  margin: EdgeInsets.only(
                      bottom: screenHeight * 0.75, right: 16, left: 16),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Colors.red,
                  // animation:CurvedAnimation(parent: controller, curve: Curves.easeIn),
                ));
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                print('close');
                Navigator.pop(buildContext);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  // ListView(
  //   children: [
  //     addressCardMethod(),
  //   ],
  // ),

  Card addressCardMethod(
      Address address, List<Address> transactions, BuildContext ctx) {
    print('printing address city');
    print(address.city);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    address.firstName  ?? "No name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [Text(address.phoneNumber ?? "0559823576")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    address.towns ?? "no city",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [Text('Deliver to doorstep')],
              ),
            ),
            Divider(
              thickness: 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: address.currentAddress ?? false,
                      shape: CircleBorder(),
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // print(value);
                        print("price");

                        print(address.price);

                        print("place");
                        print(address.towns);

                        setState(() {
                          // checkValue = value;
                          editCurrentAddressTransaction(
                              address, value, transactions);
                          cartProvider.retrievePersistedDetails(address);
                          print("persisted fee");
                          print(cartProvider.persistedFee);
                        });
                      },
                    ),
                    Text("Default Address"),
                  ],
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // address.delete();

                        _showAlertDialog(address, ctx);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                        size: 18,
                      ),
                      label: Text(
                        'Delete',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  ],
                ),
                // Row(
                //   children: [
                //     TextButton.icon(
                //       onPressed: () {
                //         Navigator.of(context).pushReplacement(MaterialPageRoute(
                //             builder: (context) => EditAddressForm(
                //                   address: address,
                //                 )));
                //       },
                //       icon: Icon(
                //         Icons.edit,
                //         color: Colors.grey,
                //         size: 18,
                //       ),
                //       label: Text(
                //         'Edit',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     )
                //   ],
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  editCurrentAddressTransaction(
      Address address, bool currentAddress, List<Address> transactions) async {
    transactions.retainWhere((element) {
      return element.currentAddress == true;
    });

    if (transactions.isNotEmpty) {
      transactions[0].currentAddress = false;
      transactions[0].save();
    }

    // print(transactions[0].firstName);
    setState(() {
      address.currentAddress = true;
      // transactions.forEach((element) {

      // });
      // address.city = cart.shipping address
      // editCurrentAddressTransaction(address, currentAddress, transactions)

      address.save();
    });

    // cartProvider.retrievePersistedDetails(address);
  }
}
