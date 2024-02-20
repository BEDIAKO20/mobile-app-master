import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:franko_mobile_app/models/product_cart.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/payment_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/util/form_helper.dart';
import 'package:franko_mobile_app/view/pages/payment/card_payment.dart';
import 'package:franko_mobile_app/view/pages/payment/cellulant_payment.dart';
import 'package:franko_mobile_app/view/pages/payment/momo_payment_page.dart';
import 'package:franko_mobile_app/view/pages/payment/payment_successful.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class OrderSummaryPage extends StatefulWidget {
  OrderSummaryPage({this.address, this.city, this.model, this.paymentType});
  final address;
  final city;
  final Billing model;
  final String paymentType;

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  var sum;
  var product;
  Billing model;
  DataU _tokenValue;
  bool isApiCallProcess = false;
  bool _orderResponse = false;

  APIService apiService;
  List<Cart> items;
  CartManager cartProvider;
  PaymentProvider paymentProvider;
  AnalyticsService analyticsService = AnalyticsService();
  var orderValue;
  var deliveryFees;
  String cashDelivery;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    items = Provider.of<CartManager>(context, listen: false).incartItems;
    model = widget.model;
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
    analyticsService.setCurrentScreen('Order_summary', 'OrderSummaryScreen');
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    cartProvider = Provider.of<CartManager>(context, listen: false);
    product = Provider.of<CartManager>(context, listen: true).incartItems;

    var customerPhoneNumber =
        Provider.of<PaymentProvider>(context, listen: false).otpPhoneNumber;
    print("cust phone No Order summary");
    print(customerPhoneNumber);

    sum = Provider.of<CartManager>(context, listen: true)
        .calculateTotalPrice(product);
    // postWithClientCertificate();
    orderValue = sum;
    if (cartProvider.shippingAddressFees != 'station') {
      sum = sum + int.parse(cartProvider.shippingAddressFees);
    }

    deliveryFees = cartProvider.shippingAddressFees;

    if (cartProvider.shippingAddressFees == 'station') {
      deliveryFees = 0;
    }
    print(sum.toInt());
    print('from order summary');

    print('time');
    print(DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.now().add(const Duration(days: 30))));

    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Summary',
              style: TextStyle(
                color: Colors.black,
                // fontSize: 24,
              )),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          height: screenHeight,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  // height: screenHeight * 0.78,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Order Summary',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildListSummaryMethod(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text(
                                'GH $orderValue',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              Text(
                                'GH $deliveryFees.00',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'GH ${sum.toString()}0',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                '${widget.address},',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                widget.city,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                this.widget.paymentType,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
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
              Expanded(
                // flex:1,
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 10,
                    child: TextButton(
                      // minWidth: screenWidth * 0.7,
                      // padding: EdgeInsets.all(10),
                      // color: secondaryColor,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20)),

                         style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.7,10)),
                            backgroundColor:  MaterialStateProperty.all<Color>(secondaryColor),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),  
                      onPressed: () {
                        //buildXmlOrder(orderValue);
                        // if (Provider.of<PaymentProvider>(context, listen: false)
                        //         .paymentType ==
                        //     'Mobile Money') {
                        //   Register(address: widget.address,city: widget.city,model: widget.model,paymentType: widget.paymentType,);
                        // } else {
                        //   _placeOrder();
                        // }

                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => CellulantPaymentPage()));
                        // CellulantPaymentPage();

                        _placeOrder();
                      },
                      child: Text('Place Order',
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      text: _orderResponse == false
          ? Text(
              "Please wait....",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            )
          : Text(
              "Loading payment....",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
    );
  }

  Container buildListSummaryMethod() {
    return Container(
        // height: screenHeight*0.4,
        child: Consumer<CartManager>(builder: (context, cartData, child) {
      return ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: cartData.incartItems.length,
          separatorBuilder: (context, index) =>
              Divider(indent: 15, endIndent: 15),
          itemBuilder: (BuildContext context, int index) {
            var product = cartData.incartItems;
            return FutureBuilder(
                future: APIService().getproduct(product[index].id.toString()),
                builder:
                    (BuildContext context, AsyncSnapshot<Products> snapshot) {
                  if (!snapshot.hasData) {
                    //orderTile(product[index]);
                    return orderTile(product[index], snapshot.data);
                    
                  }

                  return orderCard(product[index], snapshot.data);
                });
          });
    }));
  }

  Widget orderTile(Cart product, Products productDetail) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                // shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(2.0)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(product.quantity.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.clear,
              size: 16,
            ),
          )
        ],
      ),
      title: Text(
        product.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      trailing: Text(
        "GH ${product.total} ",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: secondaryColor),
      ),
    );
  }

  Widget orderCard(Cart product, Products productDetail) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                // shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(2.0)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(product.quantity.toString()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.clear,
              size: 16,
            ),
          )
        ],
      ),
      title: Text(
        product.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      trailing: Text(
        "GH ${product.total} ",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: secondaryColor),
      ),
    );
  }

  void buildXmlOrder(
    double orderValue,
  ) async {
    //convert to Int

    var amount = sum.toInt();
    print(amount);
    var payType =
        Provider.of<PaymentProvider>(context, listen: false).paymentType;
    print(<dynamic, dynamic>{
      "orderValue": amount.toString() + '00',
      "payType": payType
    });

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('TKKPG', nest: () {
      builder.element('Request', nest: () {
        builder.element('Operation', nest: () {
          builder.text('CreateOrder'); // constant string
        });
        builder.element('Language', nest: () {
          builder.text('EN');
        });
        builder.element('Order', nest: () {
          builder.element('Merchant', nest: () {
            builder.text('FRANKO');
          });
          builder.element('Amount', nest: () {
            builder.text(amount.toString() +
                '00'); // amount from total / convert to in and add 00
          });
          builder.element('Currency', nest: () {
            builder.text('936');
          });
          builder.element('Description', nest: () {
            builder.text(
                'Franko Trading online Payment'); // a text of production or live
          });
          builder.element('ApproveURL', nest: () {
            builder.text(Config.baseUrl + '/payment-successful/'); // a url
          });
          builder.element('CancelURL', nest: () {
            builder.text(Config.baseUrl + '/cancel/');
          });
          builder.element('DeclineURL', nest: () {
            builder.text('https://frankophones.com/cancel/');
          });
          builder.element('OrderType', nest: () {
            builder.text('Purchase'); // a constant string of purchase
          });
        });
      });
    });

    final createOrderXml = builder.buildDocument();

    // print(createOrderXml);

    await getResponse(createOrderXml);
  }

  Future getResponse(XmlDocument body) async {
    try {
//197.251.146.150
      Uri uri = Uri(
        scheme: 'http',
        path: '/payload',
        host: 'franko-card-api.herokuapp.com', //197.251.146.150
        // port: 8080
      );
      // Send the POST request, with full SOAP envelope as the request body.
      http.Response response = await http.post(uri,
          headers: {
            'Content-Type': 'application/xml; charset=utf-8',
            // 'SOAPAction': 'AuthenticateCredential'
          },
          body: body.toXmlString()
//'''<?xml version="1.0" encoding="UTF-8"?>\r\n<TKKPG>\r\n    <Request>\r\n        <Operation>CreateOrder</Operation>\r\n        <Language>EN</Language>\r\n        <Order>\r\n            <Merchant>TEST_ECOM250</Merchant>\r\n            <Amount>1234</Amount>\r\n            <Currency>936</Currency>\r\n            <Description>Test</Description>\r\n            <ApproveURL>/testshopPageReturn.jsp</ApproveURL>\r\n            <CancelURL>/testshopPageReturn.jsp</CancelURL>\r\n            <DeclineURL>/testshopPageReturn.jsp</DeclineURL>\r\n            <OrderType>Purchase</OrderType>\r\n        </Order>\r\n    </Request>\r\n</TKKPG>'''
          );

      var rawXmlResponse = response.body;

      print(rawXmlResponse);

      XmlDocument parsedXml = XmlDocument.parse(rawXmlResponse);

      final status = parsedXml.findAllElements('Status');
      final sessionID = parsedXml
          .findAllElements('Order')
          .first
          .findAllElements('SessionID')
          .first
          .text;
      final orderID = parsedXml
          .findAllElements('Order')
          .first
          .findAllElements('OrderID')
          .first
          .text;
      final url = parsedXml
          .findAllElements('Order')
          .first
          .findAllElements('URL')
          .first
          .text;
      final operation = parsedXml.findAllElements('Operation');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardPaymentPage(
            orderId: orderID,
            sessionId: sessionID,
          ),
        ),
      );

      print(orderID);
      // print(<String, dynamic>{
      //   "status": status.first.text,
      //   "orderID": orderID,
      //   "Operation": operation.first.text,
      //   "url": url
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  Future _placeOrder() async {
    List<dynamic> lineItems = [];
    List<dynamic> productItems = [];
    var shipping = {};

    var shippingLines = [];
    var deliveryData = {};

    deliveryData['method_id'] = 'franko_trading';
    deliveryData['method_title'] = 'Franko Trading Express';
    deliveryData['total'] = cartProvider.shippingAddressFees;

    shippingLines.add(deliveryData);

    for (Cart item in items) {
      lineItems.add({
        "product_id": item.id,
        "quantity": item.quantity,
      });
      productItems.add({
        "amount": item.price,
        "name": item.name,
        "description": item.name,
        "quantity": item.quantity,
      });
    }

    shipping["first_name"] = model.firstName;
    shipping["last_name"] = model.lastName;
    shipping["address_1"] = model.address1;
    shipping["address_2"] = model.address2;
    shipping["city"] = model.city;
    shipping["state"] = model.state;
    shipping["postcode"] = model.postcode;
    shipping["country"] = "Ghana";

    //print(lineItems);
    Map<String, dynamic> orderBody = {
      "payment_method": Provider.of<PaymentProvider>(context, listen: false)
          .paymentType, // payment provider value
      "payment_method_title":
          Provider.of<PaymentProvider>(context, listen: false).paymentType,
      "created_via": "Mobile App",
      "set_paid": false,
      "customer_id": _tokenValue.id == null ? 0 : _tokenValue.id,
      "billing": model.toJson(),
      "shipping": shipping,
      "line_items": lineItems,
      "shipping_lines": shippingLines,
    };

    setState(() {
      isApiCallProcess = true;
    });

    //print(json.encode(orderBody));
    await apiService.createOrder(orderBody).then((value) {
      //print(sum);
      print(value.toJson());
      print('printing number');
      print(
          Provider.of<PaymentProvider>(context, listen: false).otpPhoneNumber);
      bool cashOrder = false;
      Map<String, dynamic> orderData = value.toJson();
      // setState(() {

      // });

      if (value != null && value.id != null) {
        setState(() {
          _orderResponse = true;
          cashOrder = true;
        });
        var customerPhoneNumber =
            Provider.of<PaymentProvider>(context, listen: false).otpPhoneNumber;

        Map<String, dynamic> paymentResponse = {
          "order_id": value.id.toString(),
          "cust_firstname": model.firstName,
          "cust_lastname": model.lastName,
          "cust_email": model.email,
          "cust_phone": customerPhoneNumber,
          "amount": sum,
          "currency": "GHS",
          "items": productItems,
          "return_url": Config.baseUrl + "/payment-successful/",
          "cancel_url": Config.baseUrl + "/cancel/",
        };
        //print(paymentResponse);
        var payType =
            Provider.of<PaymentProvider>(context, listen: false).paymentType;

        switch (payType) {
          case "Mobile Money(App)":
            momoApiResponse(paymentResponse);
            break;

          case "MoMo & Card Payment(App)":
            // buildXmlOrder(sum);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CellulantPaymentPage(
                  orderId: value.id.toString(),
                  email: model.email,
                  amount: sum,
                  first: model.firstName,
                  last: model.lastName,
                  customerPhoneNumber: customerPhoneNumber,
                ),
              ),
            );
            // CellulantPaymentPage();
            break;

          case "Cash on Delivery(App)":
            cashOnDelivery(cashOrder, orderData);
            break;

          default:
            break;
        }
      }
    });
  }

  cashOnDelivery(value, orderData) {
    if (value != null) {
      cashDelivery = "cashOnDelivery";
      print(orderData['id']);
      analyticsService.logEcommercePurchase('cedis', sum, widget.address);
      return Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentSuccessful(
                orderId: orderData['id'].toString(),
                cOd: cashDelivery,
              )));

      //cartProvider.clearCart();
    } else {
      FormHelper.showMessage(
        context,
        "Error",
        "There was an error placing your order please try again",
        "Ok",
        () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future momoApiResponse(data) async {
    await apiService.getMomoApiResponse(data).then((value) {
      print(value.toJson());
      if (value.data != null && value.data.links.checkoutUrl != null) {
        setState(() {
          isApiCallProcess = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(
                  paymentUrl: value.data.links.checkoutUrl,
                  id: value.data.orderId,
                ),
              ));
        });
      }
    });
  }
}

//  FormHelper.showMessage(
//           context,
//           "Order Confirmed",
//           "You will be contacted by our agents soon, thank you",
//           "Ok",
//           () {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, '/account', ModalRoute.withName('/homeScreen'));

//             analyticsService.logEcommercePurchase('cedis', sum, widget.address);
//             cartProvider.clearCart();
//           },
//         );
//       } else {
//         FormHelper.showMessage(
//           context,
//           "Error",
//           "There was an error placing your order please try again",
//           "Ok",
//           () {
//             Navigator.of(context).pop();
//           },
//         );