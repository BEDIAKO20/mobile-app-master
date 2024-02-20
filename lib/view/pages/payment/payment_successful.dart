import 'package:flutter/material.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/home.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';

class PaymentSuccessful extends StatefulWidget {
  PaymentSuccessful({Key key, this.orderId, this.cOd}) : super(key: key);

  final String orderId;
  final String cOd;

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  APIService apiService = new APIService();
  CartManager cartProvider;

  @override
  void initState() {
    super.initState();
    cartProvider = Provider.of<CartManager>(context, listen: false);
  }

  updateOrderStatus(String orderId, String status, bool setPaid) async {
    apiService.updateOrderStatus(orderId, status, setPaid);
  }

  @override
  Widget build(BuildContext context) {
    updateOrderStatus(widget.orderId, 'processing', true);
    cartProvider.clearCart();
    return Container(
        child: Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Center(
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: secondaryColor,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      this.widget.cOd != null ? "Order Successfully Placed" : "Payment Successful",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: this.widget.cOd != null ? Text(
                      " Your Order with ID ${widget.orderId ?? ''} has being confirmed Successful",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ) : Text(
                      "Payment of your Order ID ${widget.orderId ?? ''} has being confirmed Successful",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    // height: 60,
                    // width: 60,
                    // color: secondaryColor,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: secondaryColor.withOpacity(0.3),
                      size: 100,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 40),
                    child: Text(
                      "Our agents will call you soon for delivery. If you need any clarification you can call us on 0501647166 | 0501570464",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Column(
                      children: [
                        Text(
                          "Thank you for Shopping with us",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Franko Trading, Phones papa fie!!",
                            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic,),
                            textAlign: TextAlign.center,

                          ),
                        ),
                      ],
                    ),
                    
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          //color: Colors.yellow,
          //height: 58.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 10, 30, 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30)),

                       style: ButtonStyle(
                            // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            // minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.7,10)),
                            backgroundColor:  MaterialStateProperty.all<Color>( secondaryColor),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),),),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Continue Shopping",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          ModalRoute.withName('/homeScreen'),
                        );
                      },
                      // color: secondaryColor,
                      // textColor: Colors.white,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    ));
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: secondaryColor,
      automaticallyImplyLeading: false,
      title: Text(
        this.widget.cOd != null ? "Order Successful" : "Payment Successful",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
