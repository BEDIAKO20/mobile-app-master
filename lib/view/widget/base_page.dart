import 'package:flutter/material.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/loader_provider.dart';
import 'package:franko_mobile_app/util/ProgressHUD.dart';
import 'package:franko_mobile_app/view/pages/home.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:franko_mobile_app/view/widget/widget_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key, this.categoryName}) : super(key: key);

  String categoryName;

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartManager>(context, listen: false).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: ProgressHUD(
          child: pageUI(),
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: secondaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      automaticallyImplyLeading: true,
      title: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
            'assets/images/logo-FTE.png',
            fit: BoxFit.contain,
          ),
      ),
      
      //  Text(
      //   this.widget.categoryName != null
      //       ? this.widget.categoryName
      //       : "Franko Trading",
      //   style: TextStyle(color: Colors.black),
      // ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
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
