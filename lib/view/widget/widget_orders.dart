import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/order_response.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/order_details.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;

  OrderWidget({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(children: [
        _orderStatus(this.orderModel.status),
        Divider(
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconText(
                Icon(Icons.edit, color: Colors.redAccent),
                Text("Order Number",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Text(
              "#${this.orderModel.id.toString()}",
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconText(
                Icon(Icons.today, color: Colors.redAccent),
                Text("Order Created",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Text(
              timeago.format(this.orderModel.dateCreated),
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TextButton(
                child: Row(
                  children: [Text("Order Details"), Icon(Icons.chevron_right)],
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                            title: "Order Details",
                            order: this.orderModel),
                      ));
                },
              ),
            ),
          ],
        )
      ]),
    );
  }

  // Widget flatButton(Widget iconText, Color color, Function onPressed) {
  //   return FlatButton(
  //     Row

  //   );
  // }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: [iconWidget, SizedBox(width: 5), textWidget],
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "processing" || status == "on-hold") {
      icon = Icon(Icons.schedule, color: Colors.orange);
      color = Colors.orange;
    } else if (status == "completed") {
      icon = Icon(Icons.check_circle_outline_outlined, color: Colors.green);
      color = Colors.green;
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "faild") {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    } else if (status == "pending") {
      icon = Icon(Icons.pending_outlined, color: Colors.blueAccent);
      color = Colors.blueAccent;
    } else if (status == "delivered") {
      icon = Icon(Icons.local_shipping_outlined, color: kPrimaryColor);
      color = kPrimaryColor;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text("Status",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ),
        Container(
          child: iconText(
              icon,
              Text(
                "Order $status",
                style: TextStyle(
                  fontSize: 15,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ],
    );
  }
}
