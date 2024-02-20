import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/provider/dashboard_provider.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/view/widget/carousel.dart';
import 'package:franko_mobile_app/view/widget/parent_categories_home.dart';
import 'package:franko_mobile_app/view/widget/widget_computer_product_cat.dart';
import 'package:franko_mobile_app/view/widget/widget_mobile_product_cat.dart';
import 'package:franko_mobile_app/view/widget/widget_new_product_cat.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:franko_mobile_app/view/widget/widget_display_product_cat.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    Key key,
    // this.analytics,
    // this.observer
  }) : super(key: key);
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Products> newProducts;
  List<Products> mobileProducts;
  List<Products> computerProducts;
  DashboardProvider dashboardData;
  AnalyticsService analyticsService = AnalyticsService();
  FirebaseStorage storage = FirebaseStorage.instance;
  bool quotaExceeded = false;

  String url =
      "https://firebasestorage.googleapis.com/v0/b/franko-trading-app.appspot.com/o/carousel_images%2Ftingg.jpg?alt=media&token=e4e2b8b6-f5c4-4867-880d-19a26cc53f23";

  String number = "0302225651";
  bool itemState = false;
  Future<void> _currentScreen() async {
    await analyticsService.setCurrentScreen(
        'Dashboard_Screen', 'DashboardScreen');
  }

  Future<void> _sendAnalytics() async {
    await analyticsService.logEvent('dashboard_open');
  }

  List imageList = [];
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    getLinks();
  }

  _makingPhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  getLinks() async {
    // var url = await storage.ref('/carousel_images').list();

    try {
      var ref = storage.ref('/AppBanner');
      var result = await ref.listAll();

      final urls = await _getDownloadLinks(result.items);
      //imageList = urls;
      setState(() {
        urls.forEach((url) {
          imageList.add(url);
        });
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        quotaExceeded = true;
        imageList.add('');
      });
    }

    // print('--Links--');
    // print(imageList);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    dashboardData = Provider.of<DashboardProvider>(context, listen: itemState);

    dashboardData.fetchNewProducts(Config.tagParam, Config.newProductTagId);
    dashboardData.fetchMobileProducts(Config.catParam, Config.mobileCatId);
    dashboardData.fetchComputerProducts(Config.catParam, Config.computersCatId);
    // dashboardData.fetchPromoProducts(Config.tagParam, Config.promoId);

    _currentScreen();
    _sendAnalytics();

    if (imageList[0].toString().isNotEmpty) {
      setState(() {
        imageUrl = imageList[0];
      });

      // print('true , it is null'+imageList[0]);

      // return Container();
    }

    // print("img url");
    // print(imageList[0].toString());

    // print(newProducts.toString() + 'dasboard');
    Widget banner() {
      return GestureDetector(
        onTap: () => _makingPhoneCall(number),
        child: SizedBox(
          height: 170,
          child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageList[0].toString(),
                    fit: BoxFit.cover,
                  )
                : Container(),
            width: screenWidth,
          ),
        ),
      );
    }

    newProduct() {
      return Container(
        child: Consumer<DashboardProvider>(
          builder: (context, snapshot, child) {
            if (snapshot.newProducts == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            if (snapshot.newProducts != null) {
              return WidgetNewProducts(
                labelName: 'New Products',
                productData: snapshot.newProducts,
                paramId: Config.newProductTagId,
              );
            }

            if (snapshot.newProducts.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          },
        ),
      );
    }

    mobileProduct() {
      return Container(
        child: Consumer<DashboardProvider>(
          builder: (context, snapshot, child) {
            if (snapshot.mobileProducts == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            if (snapshot.mobileProducts != null) {
              return WidgetMobileProducts(
                labelName: 'Mobile',
                productData: snapshot.mobileProducts,
                paramId: Config.mobileCatId,
              );
            }
            if (snapshot.mobileProducts.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          },
        ),
      );
    }

    computerProduct() {
      return Container(
        child: Consumer<DashboardProvider>(
          builder: (context, snapshot, child) {
            if (snapshot.computerProducts == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }
            if (snapshot.computerProducts != null) {
              return WidgetComputerProducts(
                  labelName: 'Computers',
                  productData: snapshot.computerProducts,
                  paramId: Config.catParam);
            }

            if (snapshot.computerProducts.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          },
        ),
      );
    }

    print('printing image List');
    print(imageList);

    return Scaffold(
      body: Container(
        color: Colors.white10,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlide(),
              ParentCategories(),
              // Container(
              //   child: BannerSlider(),
              // ),
              newProduct(),
              // Divider(),
              imageUrl.isEmpty
                  ? Container()
                  : Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: banner(),
                      ),
                    ),
              // Divider(),
              mobileProduct(),
              // Divider(),
              computerProduct()

              //WidgetDisplayProducts(tagId: Config.newProductTagId),
            ],
          ),
          // cacheExtent:9 ,
        ),
      ),
    );
  }
}
