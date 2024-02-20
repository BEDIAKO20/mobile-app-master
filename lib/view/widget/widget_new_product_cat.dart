import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';
import 'package:franko_mobile_app/view/pages/product/product_page.dart';
import 'package:franko_mobile_app/view/widget/const.dart';

class WidgetNewProducts extends StatefulWidget {
  WidgetNewProducts({Key key, this.labelName, this.productData, this.paramId})
      : super(key: key);
  final String labelName;
  List<Products> productData;
  // final String param;
  final String paramId;

  // final Products data;

  @override
  _WidgetNewProductsState createState() => _WidgetNewProductsState();
}

class _WidgetNewProductsState extends State<WidgetNewProducts> {
  // Future<List<Products>> _apiService;
  List<Products> items = [];
  bool itemState = false;

  @override
  void initState() {
    super.initState();
    //  Provider.of<DashboardProvider>(context, listen: false)
    //     .fetchHomeProducts(widget.param, widget.paramId);
    //     items =
    //     Provider.of<DashboardProvider>(context, listen: false).homeProducts;
    // _apiService = new APIService()
    //     .getProductsHome(this.widget.param, this.widget.paramId);
  }

  @override
  Widget build(BuildContext context) {
    items = widget.productData;
    // var data = json.encode(items);
    // print('widget mobile 1');
    // // log('hi----------------------' + data.toString());
    // print('hi----------------------' + data.toString());
    // print('widget mobile 2');

    return Padding(
      padding: const EdgeInsets.only(top: 8,right: 4,left: 4),
      child: Material(
        elevation: 2,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        this.widget.labelName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductPage(categoryId: this.widget.paramId),
                              ));
                        },
                        child: TextButton(
                          onPressed: () {
                            //     Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => ProductPage(
                            //         categoryId: widget.paramId,
                            //         categoryName: ''
                            //         )));
                          },
                          child: Text(
                            '',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _buildList(),
              // _productLists()
            ],
          ),
        ),
      ),
    );
  }

  // Widget _productLists() {
  //   return FutureBuilder(
  //     // future: _apiService,
  //     builder: (BuildContext context, AsyncSnapshot<List<Products>> model) {
  //       if (model.hasData) {
  //         return _buildList();
  //       }
  //       return Center(
  //         child: CircularProgressIndicator(
  //           valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildList() {
    // return Consumer<DashboardProvider>(
    //     builder: (BuildContext context, homeData, Widget child) {
    // homeData.fetchHomeProducts(widget.param, widget.paramId);
    // items = homeData.homeProducts;

    // if (items == null) {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    //     ),
    //   );
    // }

    // if (items.isNotEmpty) {

    //     itemState = false;

    // }
    //  print(itemState);

    //  var data = json.encode(items);
    // print('widget new product');
    // log('hi----------------------'+data.toString());
    // print('widget new product');

    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        height: 600,
        alignment: Alignment.center,
        child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            //items.length,
            children: items
                .map((product) => GestureDetector(
                      onTap: () {
                        // print(product);
                        // print('-new widget product -');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(product: product),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          // borderRadius: BorderRadius.circular(4),
                          //color: Colors.redAccent,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.2,
                            ),
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black12     ,
                          //     offset: Offset(0, 5),
                          //     blurRadius: 15,
                          //   )
                          // ]
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: 130,
                              height: 100,
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: product.images[0].src ??
                                    "https://cdn.icon-icons.com/icons2/1369/PNG/512/-broken-image_89881.png",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                height: 150,
                              ),
                            ),
                            Container(
                              width: 150,
                              alignment: Alignment.center,
                              child: Text(product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4, left: 4),
                              width: 100,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text('${data.price}',
                                  //     style: TextStyle(
                                  //       color: Colors.redAccent,
                                  //       fontSize: 14,
                                  //       decoration: TextDecoration.lineThrough,
                                  //       fontWeight: FontWeight.bold,
                                  //     )),
                                  Text(
                                    'GHS ${product.price}',
                                    softWrap: true,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList()));
    // });
  }
}
