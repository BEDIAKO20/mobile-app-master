import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/order_response.dart';

class OrderProvider with ChangeNotifier{
  APIService _apiservice;

  List<OrderModel> _orderList;

  List<OrderModel> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  OrderProvider()
    {
    resetStream();
  }

  void resetStream(){
     _apiservice = APIService();
  }

  fetchOrders(int orderId) async {
    List<OrderModel> orderList = await _apiservice.getOrders(orderId);
    if(_orderList == null){
      _orderList = new List<OrderModel>();
    }
    if(orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }
    notifyListeners();
  }

}