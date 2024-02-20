import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/user_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/util/custom_stepper.dart';
import 'package:franko_mobile_app/view/pages/order/address_management.dart';
import 'package:franko_mobile_app/view/view_auth/login_ui.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:franko_mobile_app/services/api_service.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key, this.analytics, this.observer});
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> product;
  String cart = "0";
  double sum;
  CartManager cartProvider;
  UserProvider userProvider;

  bool tokenValue = false;
  DataU tokenValue2;
  double textScale = 0.9;
  double screenWidth;
  AnalyticsService analyticsService = AnalyticsService();
  var deliveryLocation;
  var deliveryFees;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            String value = prefs.getString("token") ?? null;
            if (value != null) {
              tokenValue = true;
              // var token = json.decode(value);
              // tokenValue = DataU.fromJson(token);

              //tokenValue = tokenValue2.toJson();
              //print(tokenValue2.toJson());
            }
          })
        });

    _setCurrentScreen();
    // Provider.of<CartManager>(context, listen: false).clearCart();
    // print("cart cleared");

    Provider.of<CartManager>(context, listen: false).savedAddress();
  }

  _setCurrentScreen() async {
    await analyticsService.setCurrentScreen('cart_screen', 'cartScreen');
    print('cart screen called');
  }

  generatePrice(id) async {
    var productData = await APIService().getproduct(id);
    var currentPrice = productData.price;
    return currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    BuildContext pageContext = context;
    // String price = Provider.of<CartManager>(context, listen: false).itemPrice;

    //final  orders =  new Billing(firstName: null, lastName: null, city: null, address1: null, email: null, phone: null );
    product = Provider.of<CartManager>(context, listen: true).incartItems;
    sum = Provider.of<CartManager>(context, listen: true)
        .calculateTotalPrice(product);
    cart = sum.toString();
    cartProvider = Provider.of<CartManager>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);

    // print(cartProvider.carts.toString()+"cart");
    print('--printing-- address----');
    print(cartProvider.shippingAddressFees);
    deliveryLocation = cartProvider.shippingAddressLocation;

    Size size = MediaQuery.of(context).size;
    // print(cartProvider.incartItems.toString() + ' incarts');

    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 400) {
      setState(() {
        textScale = 0.65;
      });
    }

    // userProvider.loadUserDetails().toString();

    // print(Provider.of<CartManager>(context, listen: false).incartItems);
    return Scaffold(
      body: Container(
        margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        child: Container(
          child: product.isNotEmpty
              ? makeListTitle(cartProvider, pageContext)
              : Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OOPS...YOUR CART IS EMPTY!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          //  color: Colors.transparent,
                          child: SvgPicture.asset(
                            "assets/icons/shopping-cart-empty.svg",
                            width: size.width * 0.4,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: product.isNotEmpty
          ? BottomAppBar(
              child: Container(
                //height: 59.0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Wrap(
                      //             children: [
                      //               Text(
                      //                 'Location : ${cartProvider.shippingAddressLocation}',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Delivery Price : GHS ${cartProvider.shippingAddressFees}',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "TOTAL:  GH $cart",
                                textScaleFactor: textScale,
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
                                  analyticsService
                                      .setFiamTrigger('add_to_cart');
                                  if (tokenValue) {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => VerifyAddress(),
                                    //   ),
                                    // );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddressManagementPage(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 15.0),
                                  child: Text(
                                    'CHECKOUT',
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
                    ],
                  ),
                ),
              ),
            )
          : Row(),
    );
  }

  makeListTitle(CartManager cartProvider, pageContext) => ListView.builder(
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          print('--loading address fees');
          print(cartProvider.shippingAddressFees);

         var cartProducts =
              cartProvider.getCurrentPrice(product[index].id);

          print('cart products');
          print(cartProducts);

          // APIService apiService = APIService();

          // apiService.getproduct('8');

          return Card(
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  leading: Container(
                    width: 100,
                    height: 300,
                    alignment: Alignment.center,

                    child: CachedNetworkImage(
                      imageUrl: product[index].image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.hide_image_rounded),
                    ),
                    // Image.network(product[index].image)
                  ),
                  title: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(product[index].name.toLowerCase(),
                          style: TextStyle(color: Colors.black))),
                  subtitle: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("GHS " + product[index].price.toString(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold))
                      //priceTexMethod(context, index),
                      ),
                ),
                Divider(
                  color: Colors.black,
                  //height: 10,
                  thickness: 0.2,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<StadiumBorder>(
                            StadiumBorder()),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                      ),

                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text("Remove",
                                style: TextStyle(color: Colors.white))
                          ]),
                      onPressed: () {
                        _showAlertDialog(product[index], pageContext);
                      },

                      // padding: EdgeInsets.all(8),
                      // color: Colors.redAccent,
                      // shape: StadiumBorder(),
                    ),
                    CustomStepper(
                        lowerLimit: 1,
                        upperLimit: 20,
                        stepValue: 1,
                        iconSize: 25.0,
                        value: product[index].quantity == 0
                            ? 1
                            : product[index].quantity,
                        onIncrementChange: (val) {
                          cartProvider
                              .incrementQuantityOfProduct(product[index]);
                        },
                        onDecrementChange: (val) {
                          cartProvider
                              .decrementQuantityOfProduct(product[index]);
                        },
                        onChange: (value) {
                          setState(() {
                            product[index].quantity = value;
                          });
                        }),
                  ],
                ),
              ],
            ),
          );
        },
      );

  priceTexMethod(BuildContext context, int index) {
    // Provider.of<CartManager>(context, listen: false).itemPrice;

    String price = Provider.of<CartManager>(context, listen: false)
        .generatePrice(product[index].id.toString())
        .toString();

    print(price);
    return FutureBuilder(
        future: Provider.of<CartManager>(context, listen: false)
            .generateCartPrice(product[index].id.toString()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          print(snapshot.data.toString());
          return Text("GHS " + snapshot.data.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
        });
  }

  void _showAlertDialog(product, ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext buildContext) {
        double screenHeight = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: Text(
            'Remove from Cart',
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
                  'Do you want to delete this item ?',
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
                //  Navigator.pop(ctx);
                cartProvider.deleteFromCart(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '${product.name} deleted sucessfully',
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
}
