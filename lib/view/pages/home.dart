import 'package:badges/badges.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/provider/cart_provider.dart';
import 'package:franko_mobile_app/provider/connectvity_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/view/pages/cart/cart_page.dart';
import 'package:franko_mobile_app/view/pages/category/categories_page.dart';
import 'package:franko_mobile_app/view/pages/dashboard/dashboard.dart';
import 'package:franko_mobile_app/view/pages/profile/profile_screen.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:franko_mobile_app/view/widget/widget_search_bar.dart';
import 'package:new_version_plus/new_version_plus.dart';
// import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.index, this.logValue, this.analytics, this.observer})
      : super(key: key);

  int index;
  String logValue;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NewVersionPlus newVersion;
  String release = "";

  String _title;
  AnalyticsService analyticsService = AnalyticsService();
  var cart;
  String tabTitle = 'Franko Trading';
  // var cartValue = false;
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartManager>(context, listen: false).getData();
      _logOutMsg();
    });

    analyticsService.logEvent('init_Home');
    analyticsService.setCurrentScreen('Home_screen', 'HomeScreen');

    newVersion = NewVersionPlus(
      iOSId: 'com.frankotrading.frankotrading',
      androidId: 'com.frakotg.enterapp',
    );

    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      _checkVersion(newVersion);
    }

    // _userType();
    _title = "Franko Trading";
  }

  // Future<void> _currentScreen() async {
  //   await widget.analytics.setCurrentScreen(
  //       screenName: 'Home_Screen', screenClassOverride: 'HomeScreen');
  // }

  // Future<void> _sendAnalytics() async {
  //   await widget.analytics.logEvent(
  //       name: 'home_open',
  //       parameters: <String, dynamic>{'init_state': 'started'});
  // }

  // Future<void> _userType() async {
  //   await widget.analytics.setUserProperty(name: 'Dynamo', value: 'Developer');
  // }

  basicStatusCheck(NewVersionPlus newVersion) async {
    final version = await newVersion.getVersionStatus();
    if (version != null) {
      release = version.releaseNotes ?? "";
      setState(() {});
    }

    print('printing version');
    print(release);
    newVersion.showAlertIfNecessary(
      context: context,
      launchModeVersion: LaunchModeVersion.external,
    );
  }

  void _checkVersion(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'App Update Available',
      dialogText: 'A newer version of the app is available',
      updateButtonText: 'Update Now',
      dismissButtonText: 'Later',
    );
    // NewVersion(
    //   context: context,
    //   //iOSId: 'com.google.Vespa',
    //   androidId: 'com.frakotg.enterapp',
    // ).showAlertIfNecessary();
  }

  //int _loop = 0;
  int _index = 0;
  List list = [];
  int trueIndex;
  List<Widget> _widgetList = [
    Dashboard(),
    CategoriesPage(),
    CartPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    trueIndex = widget.index;
    print("true index");
    print(trueIndex);
    print(widget.index);

    // _index = trueIndex;
    if (trueIndex == null) {
      print("widget index is empty");
    } else {
      setState(() {
        _index = widget.index;
      });
    }
    Future<bool> onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Do you want to exit the app'),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes'))
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          // key: _scaffoldKey,
          appBar: _buildAppBar(screenWidth),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Home', //Home
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.menu),
                label: 'Categories', //Categoreis
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart', //Cart
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.person),
                label: ' Account', //Account
              ),
            ],
            elevation: 1,
            iconSize: 25,
            unselectedFontSize: 13.2,
            selectedFontSize: 15,
            selectedItemColor: Color(0xFFFFC107),
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            onTap: (index) {
              onTabTapped(index);
              setState(() {
                _index = index;
                trueIndex = index;
                widget.index = index;
              });
            },
          ),
          body:
              Consumer<ConnectivityProvider>(builder: (context, model, child) {
            if (model.isOnline != null) {
              return model.isOnline
                  ? _widgetList.elementAt(_index)
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(Icons.wifi_off, size: 50),
                          ),
                          Text(
                            'No internet Connection !',
                            textScaleFactor: 1.5,
                          )
                        ],
                      ),
                    );
            }
            return _widgetList.elementAt(_index);
            // return Container(
            //   child: Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // );
          })),
    );
  }

  Widget _buildAppBar(screenWidth) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      backgroundColor: secondaryColor,
      automaticallyImplyLeading: true,
      leadingWidth: screenWidth * 0.4,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset(
          'assets/images/logo-FTE.png',
          fit: BoxFit.contain,
        ),
      ),
      // title: Text(
      //   _title,
      //   style: TextStyle(color: Colors.white),
      // ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () async {
            showSearch(context: context, delegate: ProductSearch());
          },
          color: Colors.black,
        ),
        _shoppingCartBadge(),
        //cart == 0 ? _emptyCart() : _shoppingCartBadge(),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _index = index;
      switch (index) {
        case 0:
          {
            _title = 'Franko Trading';
          }
          break;
        case 1:
          {
            _title = 'Categories';
          }
          break;
        case 2:
          {
            _title = 'Carts';
          }
          break;
        case 3:
          {
            _title = 'Account';
          }
          break;
      }
    });
  }

  Widget _shoppingCartBadge() {
    return Consumer<CartManager>(builder: (context, cartData, child) {
      return Badge(
        position: BadgePosition.topEnd(top: 0, end: 3),
        showBadge: cartData.incartItems.length == 0 ? false : true,
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(
          cartData.incartItems.length.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _index = 2;
                trueIndex = 2;
                widget.index = 2;
              });
              print(_index.toString() + 'tapped index');
              // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Home()));
            }),
      );
    });
  }

  _logOutMsg() {
    double screenHeight = MediaQuery.of(context).size.height;
    if (this.widget.logValue == "logout") {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "You've Logged out sucessfully",
          style: TextStyle(color: Colors.white),
        ),
        margin:
            EdgeInsets.only(bottom: screenHeight * 0.77, right: 16, left: 16),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.redAccent,
        // animation:CurvedAnimation(parent: controller, curve: Curves.easeIn),
      ));
    } else {
      return;
    }
  }
}
