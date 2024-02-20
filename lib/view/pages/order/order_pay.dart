import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/create_orders_model.dart';
import 'package:franko_mobile_app/provider/payment_provider.dart';
import 'package:franko_mobile_app/view/pages/order/order_summary.dart';
import 'package:franko_mobile_app/view/view_auth/register_otp_number.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:provider/provider.dart';

class OrderPayPage extends StatefulWidget {
  const OrderPayPage({
    Key key,
    this.model,
  }) : super(key: key);

  final Billing model;
  // final String paymentType;

  @override
  State<OrderPayPage> createState() => _OrderPayPageState();
}

class _OrderPayPageState extends State<OrderPayPage> {
  String selectedRole = "Writer";
  String paymentType;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    print('widget model object');
    print(widget.model);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Payment Options",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
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
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                _buildSelector(
                  context: context,
                  name: "MoMo & Card Payment(App)",
                  subtitle: Text('Pay with Visa or Mastercard'),
                  secondary: Padding(
                    child: Image.asset(
                      'assets/images/fidelity.png',
                      //height: 20,
                      //alignment: Alignment.bottomCenter,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                _buildSelector(
                  context: context,
                  name: "Cash on Delivery(App)",
                  subtitle: Text('Pay Cash on delivery'),
                  secondary: Padding(
                    child: Image.asset(
                      'assets/images/cash.png',
                      height: 40,
                      //width: 100,
                      alignment: Alignment.bottomCenter,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  ),
                ),
              ],
            ),
            Spacer(),

            SizedBox(
              // height: 10,
              child: TextButton(
                // minWidth: screenWidth * 0.7,
                // padding: EdgeInsets.all(10),
                // color: paymentType == null
                //     ? secondaryColor.withOpacity(0.2)
                //     : secondaryColor,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),

                    style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                            minimumSize: MaterialStateProperty.all<Size>(Size(screenWidth * 0.7,10)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                            
                            backgroundColor: MaterialStateProperty.all<Color>(paymentType == null
                    ? secondaryColor.withOpacity(0.2)
                    : secondaryColor,),
                           ),
                onPressed: paymentType == null
                    ? () {}
                    : () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => OrderSummaryPage(
                        //           address:widget.model.address1,
                        //           city: widget.model.city,
                        //           model: widget.model,
                        //           paymentType: paymentType,
                        //         )));

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Register(
                              address: widget.model.address1,
                              city: widget.model.city,
                              model: widget.model,
                              paymentType: paymentType,
                            ),
                          ),
                        );

                        if (Provider.of<PaymentProvider>(context, listen: false)
                                .paymentType ==
                            'MoMo & Card Payment(App)') {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                              
                          //      OrderSummaryPage(
                          //       address: widget.model.address1,
                          //       city: widget.model.city,
                          //       model: widget.model,
                          //       paymentType: paymentType,
                          //     ),
                          //   ),
                          // );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Register(
                                address: widget.model.address1,
                                city: widget.model.city,
                                model: widget.model,
                                paymentType: paymentType,
                              ),
                            ),
                          );
                        } else if (Provider.of<PaymentProvider>(context,
                                    listen: false)
                                .paymentType ==
                            "Mobile Money") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>Register(
                                address:widget.model.address1 ,
                                city: widget.model.city,
                                 model: widget.model,
                                paymentType: paymentType,
                              )
                              
                              //  OrderSummaryPage(
                              //   address: widget.model.address1,
                              //   city: widget.model.city,
                              //   model: widget.model,
                              //   paymentType: paymentType,
                              // ),


                            ),
                          );
                        } else if (Provider.of<PaymentProvider>(context,
                                    listen: false)
                                .paymentType ==
                            "Cash on Delivery(App)") {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryPage(
                                address: widget.model.address1,
                                city: widget.model.city,
                                model: widget.model,
                                paymentType: paymentType,
                              ),
                            ),
                          );
                        }
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
            //           builder: (context) => OrderSummaryPage()));
            //     },
            //     child: Text('Next', style: TextStyle(color: Colors.green)),
            //   ),
            // ),
            SizedBox(
              height: 40,
            ),
          ],
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
