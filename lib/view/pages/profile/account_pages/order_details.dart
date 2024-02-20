import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/order_response.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/account_base_page.dart';


class OrderDetailsPage extends AccountBasePage {
  OrderDetailsPage({Key key, this.title, this.order,}) : super(key: key);

  OrderModel order;
  String title;

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends AccountBasePageState<OrderDetailsPage> {
  @override
  Widget pageUI(BuildContext context) {
    return orderDetailsUI(this.widget.order);
  }

  Widget orderDetailsUI(OrderModel ordermodel) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text("#${ordermodel.id.toString()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent),),
        Text("${ordermodel.dateCreated.toString()}", style: TextStyle( fontSize: 14,),),
        SizedBox(
          height: 20,
        ),
       
        Text(
          "Delivered To",
         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent),
        ),
        Text("${ordermodel.billing.firstName} ${""} ${ordermodel.billing.lastName}", style: TextStyle( fontSize: 14,),),
        Text(ordermodel.billing.address1, style: TextStyle( fontSize: 14,),),
        Text(ordermodel.billing.city, style: TextStyle( fontSize: 14,),),
        Text(ordermodel.billing.phone, style: TextStyle( fontSize: 14,),),
        SizedBox(
          height: 20,
        ),
        Text("Payment Method",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent),),
        Text(ordermodel.paymentMethod),
        Divider(color: Colors.grey),
        Text(
          "Order Status",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.redAccent),
        ),
        Text(ordermodel.status, style: TextStyle( fontSize: 14,),),
        Divider(color: Colors.grey),
        _listOrderItems(ordermodel),
        Divider(color: Colors.grey),
         Container(
           child: Column(
             children: [
               ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(2),
                title:new Text("Subtotal", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),) ,
                trailing: new Text("GHS ${ordermodel.totalAmount}", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
               ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(2),
                title:new Text("Delivery Charges", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),) ,
                trailing: new Text("GHS ${ordermodel.shippingTotal}", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
               ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(2),
                title:new Text("Total", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),) ,
                trailing: new Text("GHS ${ordermodel.total}", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
             ],
           ),
         )
      ]),
    );
  }

  Widget _listOrderItems(OrderModel model) {
    return ListView.builder(
      itemCount: model.lineItems.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _productItems(model.lineItems[index]);
      },
    );
  }

  Widget _productItems(LineItems products) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.all(2),
          onTap: () {},
          title: new Text(products.name, style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),),
          subtitle: Padding(
            padding: EdgeInsets.all(1),
            child: new Text("Qty ${products.quantity}", style: TextStyle( fontSize: 14,),),
          ),
          trailing: new Text("GHS ${products.price * products.quantity}", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),),
        ),
        
       
      ],
    );
  }
}
