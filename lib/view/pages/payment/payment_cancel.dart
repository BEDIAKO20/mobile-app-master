
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/home.dart';
import 'package:franko_mobile_app/view/pages/order/address_management.dart';



class PaymentCancel extends StatefulWidget {
  PaymentCancel({Key key, this.orderId}) : super(key: key);

  String orderId;

  @override
  _PaymentCancelState createState() => _PaymentCancelState();
}

class _PaymentCancelState extends State<PaymentCancel> {
  APIService apiService = new APIService();

  updateOrderStatus(String orderId, String status, bool setPaid) async {
    apiService.updateOrderStatus(orderId, status, setPaid);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.orderId);
    updateOrderStatus(widget.orderId, 'cancelled', false);
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
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Text(
                      "Oops! Payment Failed",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 40),
                    child: Text(
                      "Payment of your Order ID ${widget.orderId} could not be processed, please try again",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(

                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30)),
                      style: ButtonStyle(
                            // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            // minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.7,10)),
                            // foregroundColor:  MaterialStateProperty.all<Color>(secondaryColor),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Go To Home",
                          style: TextStyle(fontSize: 18, backgroundColor: Colors.green, color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=> Home(),
                          ),
                        );
                      },
                      // color: Colors.green,
                      // textColor: Colors.white,
                    ),
                  ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Please Try Again",
                          style: TextStyle(fontSize: 18,color:Colors.white, ),
                        ),
                      ),

                      style: ButtonStyle(
                            // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            // minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.7,10)),
                            backgroundColor:  MaterialStateProperty.all<Color>( Colors.red),

                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),),),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressManagementPage(),
                            ));
                      },
                      // color: Colors.red,
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
      backgroundColor: Colors.red,
      automaticallyImplyLeading: false,
      title: Text(
        "Payment Error",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
