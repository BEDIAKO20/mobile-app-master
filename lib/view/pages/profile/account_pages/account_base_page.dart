import 'package:flutter/material.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/view/pages/home.dart';
import 'package:franko_mobile_app/view/widget/widget_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class AccountBasePage extends StatefulWidget {
  AccountBasePage({Key key, this.title}) : super(key: key);

 final String title;

  @override
  AccountBasePageState createState() => AccountBasePageState();
}

class AccountBasePageState<T extends AccountBasePage> extends State<T> {
  
 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: _buildAppBar(this.widget.title != null ? this.widget.title : "Franko Trading"),
        body: Container(
          child: pageUI(context),
        ),
      );
  }

  Widget pageUI(BuildContext context) {
    return null;
  }

  Widget _buildAppBar(title) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      automaticallyImplyLeading: true,
      title: Text(title,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearch());
            },
            color: Colors.black),
        _shoppingCartBadge(),
      ],
    );
  }

  Widget _shoppingCartBadge() {
    return Consumer<CartManager>(builder: (context, cartData, child) {
      return Badge(
        showBadge: cartData.incartItems.length == 0 ? false : true,
        position: BadgePosition.topEnd(top: 0, end: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          cartData.incartItems.length.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext buildContext) => Home(index: 2,)),);
          },
        ),
      );
    });
  }
}
