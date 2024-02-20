import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:franko_mobile_app/services/analytics.dart';
import 'package:franko_mobile_app/view/pages/brands_page.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  APIService _apiService;
  double screenWidth;
  int gridCount = 3;

  List<ProductCategory> prodData;
  List<ProductCategory> brandData;
  AnalyticsService analyticsService = AnalyticsService();

  @override
  void initState() {
    _apiService = new APIService();
    super.initState();
  }

  _setCurrentScreen() async {
    await analyticsService.setCurrentScreen(
        'Categories_screen', 'CategoriesScreen');
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    _setCurrentScreen();

    if (screenWidth <= 400) {
      setState(() {
        gridCount = 2;
      });
    }
    return Container(
      child: _categoriesList(),
    );
  }

  Widget _categoriesList() {
    return new FutureBuilder<List<ProductCategory>>(
        future: _apiService.getCategories(),
        builder: (
          BuildContext context,
          model,
        ) {
          if (model.hasData) {
            print('category list');
            print(model.data.toString());
            return _tabs(model.data);
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        });
  }

  Widget _brandList(productId) {
    print("productId");
    print(productId);
    return new FutureBuilder(
        future: _apiService.getbrands(productId),
        builder: (
          BuildContext context,
          model,
        ) {
          if (model.hasData) {
            print('brandlist');
            print(model.data);

            return _contents(model.data);
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        });
  }

  Widget _tabs(data) {
    List<Tab> tabs = new List<Tab>();
    List<Widget> contents = new List<Widget>();
    // print("tab data");
    // print(data);

    for (int i = 0; i < data.length; i++) {
      print('printing tab info');
      print(i);
      // print(data[i].categoryId.toString() + data[i].categoryName);
      tabs.add(
        Tab(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Text(
                data[i].categoryName,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
        ),
      );
      contents.add((Container(
        child: _brandList(data[i].categoryId),
      )));
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: VerticalTabs(
              tabsWidth: 130,
              tabs: tabs,
              onSelect: (index) {
                //print(index);
              },
              contents: contents,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contents(data) {
    return GridView.count(
      crossAxisCount: gridCount,
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5,
      children: List.generate(data.length, (i) {
        print("category");
        print(data[i].categoryId.toString());
        print(data[i].categoryName);

        return GestureDetector(
          onTap: () {
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrandsPage(
                    categoryId: data[i].categoryId.toString(),
                    categoryName: data[i].categoryName),
              ),
            );
          },
          child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data[i].categoryName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        );
      }),
    );
  }
}
