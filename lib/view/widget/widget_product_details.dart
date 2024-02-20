import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/cart_products.dart';
import 'package:franko_mobile_app/models/cities.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/models/variable_product_model.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/loader_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/util/expand_text.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:franko_mobile_app/view/widget/widget_related_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  ProductDetailsWidget(
      {Key key, this.quantity, this.data, this.variableProducts})
      : super(key: key);

  Products data;

  List<VariableProduct> variableProducts;
  VariableProduct newValue;

  int quantity;

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget>
    with SingleTickerProviderStateMixin {
  final CarouselController _controller = CarouselController();

  CartProduct cartProducts = new CartProduct();

  Products carproduct = new Products();
  AnalyticsService analyticsService = AnalyticsService();

  double screenHeight;
  double screenWidth;
  double textScale = 0.9;

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
  List<String> newregions = [];
  bool cityState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartManager>(context, listen: false).savedAddress();
    });
    _setCurrentScreen();
    // getCities(dropdownvalue);
    getRegions();
  }

  _setCurrentScreen() async {
    await analyticsService.setCurrentScreen(
        'ProductDetailsWidget_screen', 'ProductDtailsWidgetScreen');
  }

  CollectionReference _locations =
      FirebaseFirestore.instance.collection('Regions');

  CartManager cartData;

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

    // print('---getCities Called--');
    // print(dropdownvalue);
    // print(cities.last['Location']);

    // print('--Printing Accra ---');
    // print(await cities[3]);

    cities.forEach((city) {
      // print(city);
      towns.add(Cities.fromJson(city));
    });
    setState(() {
      places = towns;
    });

    // print('--places--');
    // print(places.first.Location);
    // print(towns);

    // print('---towns---');
    // print(towns.first.Location);
  }

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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // Provider.of<CartManager>(context,listen: false).savedAddress();

    cartData = Provider.of<CartManager>(context, listen: false);

    // if (cartData.shippingAddressLocation != null) {
    //                       cityState = true;
    //                     } else {
    //                       cityState = false;
    //                     }

    //getCities();
    print('province');
    print(myIds);

    if (screenWidth <= 500) {
      setState(() {
        textScale = 0.65;
      });
    }
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              color: Colors.grey[200],
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            productImages(widget.data.images, context),
                            SizedBox(height: 20),
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.data.name,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey[850],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () async {
                                //     String deeplink =
                                //         await FirebaseDynamicLinkService
                                //             .createDynamicLink(
                                //                 true, widget.data);

                                //     print(deeplink);
                                //   },
                                //   icon: Icon(Icons.share),
                                // )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: widget.data.type == "variable",
                                  child: selectDropdown(
                                      context,
                                      "",
                                      this.widget.variableProducts,
                                      widget.newValue, (VariableProduct value) {
                                    widget.data.price = value.price;
                                    widget.newValue = value;
                                  }),
                                ),
                                Text(
                                  "GHS ${widget.data.price}",
                                  // textScaleFactor: textScale,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // Container(
                      //   color: Colors.white,
                      //   child: Row(
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 20, vertical: 5),
                      //         child: Text(
                      //           'Choose Location',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 18),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

//                       Container(
//                         width: screenWidth,
//                         color: Colors.white,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: screenWidth * 0.8,
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: DropdownButtonFormField(
//                                   decoration: InputDecoration(
//                                       //contentPadding: EdgeInsets.all(6),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                         color: Colors.black54,
//                                         width: 1,
//                                       )),
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                         color: Colors.black54,
//                                         width: 1,
//                                       ))),
//                                   value: dropdownvalue ??
//                                       cartData.shippingAddressRegions,
//                                   icon: Icon(Icons.keyboard_arrow_down),
//                                   items: province.map((region) {
//                                         return DropdownMenuItem(
//                                           onTap: () {
//                                             setState(() {
//                                               regionValue = region;
//                                               cityState = false;
//                                             });
// //                                             cartData
// //                                                 .getShippingFee(addressData);

// //                                             cartData.saveAddressDetails(
// //                                                 addressData);

//                                             print('--regional value--');
//                                             print(regionValue);
//                                           },
//                                           value: region,
//                                           child: Text('$region'),
//                                         );
//                                       }).toList() ??
//                                       [],
//                                   onChanged: (newValue) {
//                                     setState(() {
//                                       _category = null;
//                                       dropdownvalue = newValue;
//                                       cartData.saveRegionalvalue(regionValue);

//                                       getCities(dropdownvalue);
//                                     });
//                                   },
//                                   hint: Text('Select Region'),
//                                   isExpanded: false,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // SizedBox(
//                       //   height: 10,
//                       // ),

//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         color: Colors.white,
//                         width: screenWidth,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: screenWidth * 0.8,
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 child: DropdownButtonFormField(
//                                   isExpanded: true,
//                                   decoration: InputDecoration(
//                                       //contentPadding: EdgeInsets.all(6),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                         color: Colors.black54,
//                                         width: 1,
//                                       )),
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                         color: Colors.black54,
//                                         width: 1,
//                                       ))),

//                                   value: _category,
//                                   //elevation: 16,
//                                   icon: Icon(Icons.keyboard_arrow_down),
//                                   hint: Text(
//                                       '${cartData.shippingAddressLocation ?? 'Enter City'}'),
//                                   isDense: true,
//                                   // underline: Container(
//                                   //   height: 2,
//                                   //   color: Colors.black,
//                                   // ),
//                                   items: places.map<DropdownMenuItem<Cities>>(
//                                           (document) {
//                                         return DropdownMenuItem<Cities>(
//                                           onTap: () {
//                                             setState(() {
//                                               cartDropdownData = document;
//                                               //print(cartData.shippingAddressFees);
//                                               addressData = {
//                                                 'Location': document.location,
//                                                 'Charge': document.charge,
//                                                 'Region': cartData
//                                                     .shippingAddressRegions
//                                               };
//                                               cartData.savedAddress();

//                                               charge = document.charge;
//                                             });

//                                             // print('---address details---');
//                                             // print(addressData);
//                                             cartData
//                                                 .getShippingFee(addressData);

//                                             cartData.saveAddressDetails(
//                                                 addressData);
//                                           },
//                                           value: document,
//                                           child: Text(
//                                             document.location ?? '',
//                                             style: TextStyle(),
//                                           ),
//                                         );
//                                       }).toList() ??
//                                       [],
//                                   onChanged: (newValue) {
//                                     setState(() {
//                                       _category = newValue;
//                                       print(newValue);
//                                     });
//                                     // print('printing category');
//                                     // print(_category);
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

                      // Column(
                      //   children: [
                      //     ListTile(
                      //         tileColor: Colors.white,
                      //         leading: CircleAvatar(
                      //           child: Icon(Icons.local_shipping),
                      //         ),
                      //         title: Text('Home or Office Delivery'),
                      //         subtitle: Column(
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 cartData.shippingAddressFees != null
                      //                     ? Text(
                      //                         cartData.shippingAddressFees ==
                      //                                 'station'
                      //                             ? 'Outside Delivery Zone'
                      //                             : 'Shipping Fee GHS ${cartData.shippingAddressFees}',
                      //                         softWrap: false,
                      //                         style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       )
                      //                     : Text(
                      //                         'Please choose delivery location',
                      //                         softWrap: false,
                      //                         style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                         ),
                      //                       ),
                      //               ],
                      //             ),
                      //             Row(
                      //               children: [
                      //                 Text('Delivery is within 48 hrs'),
                      //               ],
                      //             )
                      //           ],
                      //         )

                      //         // Text('Shipping GHS ${charge} \n Delivery within 48 hrs',),
                      //         ),
                      //   ],
                      // ),

                      SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            ExpandText(
                              labelHeader: "Specifictions",
                              //shortDesc: data.shortDescription,
                              desc: widget.data.description,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            RelatedProducts(
                                labelname: "Customers also viewed",
                                product: this.widget.data.relatedIds),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // end of page
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          //color: Colors.yellow,
          height: 58.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Price:  GHS ${widget.data.price}",
                      textScaleFactor: 0.8,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                       style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          secondaryColor),
                                ),
                      onPressed: () {
                          addToCart();
                        // setState(() {
                        //    print("state change");
                        //   });
                        // cartData.shippingAddressFees != null
                        //?addToCart();
                        // : ScaffoldMessenger.of(context)
                        //     .showSnackBar(SnackBar(
                        //     content: Text(
                        //       'Sorry! please choose delivery location',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     margin: EdgeInsets.only(
                        //         bottom: screenHeight * 0.85,
                        //         right: 16,
                        //         left: 16),
                        //     behavior: SnackBarBehavior.floating,
                        //     duration: Duration(milliseconds: 1500),
                        //     backgroundColor: Colors.red,

                        //     // animation:CurvedAnimation(parent: controller, curve: Curves.easeIn),
                        //   ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0),
                        child: Text(
                          'ADD TO CART',
                          textScaleFactor: textScale,
                          style: TextStyle(
                            backgroundColor: secondaryColor,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // color: secondaryColor,
                      // textColor: Colors.white,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  void addToCart() {
    Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(true);
    var cartProvider = Provider.of<CartManager>(context, listen: false);
    carproduct.quantity = this.widget.quantity == null
        ? this.widget.quantity = 1
        : this.widget.quantity;
    carproduct.id = widget.data.id;
    carproduct.price = widget.data.price;
    carproduct.name = widget.data.name;
    carproduct.images = widget.data.images;
    // carproduct.shippingAddressFee = cartDropdownData.Charge;
    // carproduct.shippingAddressLocation =
    //     cartDropdownData.Location;
    // cartProvider.shippingAddress = addressData;

    cartProvider.addCartItem(carproduct);
    Provider.of<LoaderProvider>(context, listen: false).setLoadingStatus(false);

    int productQuantity = cartProvider.getProductQuantity(carproduct);
    analyticsService.logAddToCart(currencySymbol, cartProvider.cartItems,
       0.0);
    // print(cartProvider.itemQuantity);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$productQuantity ${carproduct.name}(s) added sucessfully',
        style: TextStyle(color: Colors.white),
      ),
      margin: EdgeInsets.only(bottom: screenHeight * 0.85, right: 16, left: 16),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1500),
      backgroundColor: secondaryColor,
      // animation:CurvedAnimation(parent: controller, curve: Curves.easeIn),
    ));
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, ind) {
                return Container(
                  child: Image.network(
                    images[index].src,
                    fit: BoxFit.fitWidth,
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 1.0,
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1,
              ),
              carouselController: _controller,
            ),
          ),
          Positioned(
              top: 100,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _controller.previousPage();
                },
              )),
          Positioned(
              top: 100,
              left: MediaQuery.of(context).size.width - 80,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _controller.nextPage();
                },
              ))
        ],
      ),
    );
  }

  Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    VariableProduct attribute,
    Function onChanged, {
    Function onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          height: 75,
          width: 200,
          padding: EdgeInsets.only(top: 5),
          child: new DropdownButtonFormField<VariableProduct>(
            hint: new Text('Select Price'),
            value: attribute,
            isDense: true,
            decoration: fieldDecoration(context, "", ""),
            onChanged: (newValue) {
              FocusScope.of(context).requestFocus(new FocusNode());
              onChanged(newValue);
            },
            items: data != null
                ? data.map<DropdownMenuItem<VariableProduct>>(
                    (VariableProduct data) {
                      return DropdownMenuItem<VariableProduct>(
                        value: data,
                        child: new Text(
                          data.attributes.first.option,
                          style: new TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  ).toList()
                : null,
          )),
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
        contentPadding: EdgeInsets.all(6),
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: kPrimaryColor,
          width: 1,
        )),
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: kPrimaryColor,
          width: 1,
        )));
  }
}
