import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/order_response.dart';
import 'package:franko_mobile_app/provider/order_provider.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/account_base_page.dart';

import 'package:franko_mobile_app/view/widget/widget_orders.dart';
import 'package:provider/provider.dart';

class OrdersPage extends AccountBasePage {
  OrdersPage({Key key, this.title, this.orderId}) : super(key: key);

final String title;
final int orderId;

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends AccountBasePageState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders(this.widget.orderId);
    //print(this.widget.orderId);
  }

  @override
  Widget pageUI(BuildContext context) {
    return new Consumer<OrderProvider>(builder: (context, ordersModel, child){
      if(ordersModel.allOrders != null && ordersModel.allOrders.length > 0){
         return _listView(context, ordersModel.allOrders);  
      }else{
        return Center(child: CircularProgressIndicator());
      }
      //  return _listView(context, ordersModel.allOrders);
      
    });
  }

  Widget _listView(BuildContext context, List<OrderModel> order){
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Card(
              elevation: 0, shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(16.0),),
              child:OrderWidget(orderModel: order[index],),
            );
          },
        )
      ],
    );
  }
}