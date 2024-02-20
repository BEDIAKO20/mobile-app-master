
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/product/product_page.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';
import 'package:franko_mobile_app/view/widget/const.dart';

class WidgetHomeProducts extends StatefulWidget {
  WidgetHomeProducts(
      {Key key, this.labelName, this.param, this.paramId, this.data})
      : super(key: key);
  final String labelName;
  final String param;
  final String paramId;

  final Products data;

  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {

  Future<List<Products>> _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = new APIService().getProductsHome(this.widget.param, this.widget.paramId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    this.widget.labelName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: GestureDetector(
                    // onTap: () {
                    //  
                    // },
                    child: TextButton(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductPage(categoryId: this.widget.paramId),
                          ));
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            _productLists()
          ],
        ),
      ),
    );
  }

  Widget _productLists() {
    return FutureBuilder(
      future:
          _apiService,
      builder: (BuildContext context, AsyncSnapshot<List<Products>> model) {
        if (model.hasData) {
          return _buildList(model.data);
        }
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        );
      },
    );
  }

  Widget _buildList(items) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
        height: 600,
        alignment: Alignment.center,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          //items.length,
          children: List.generate(items.length, (index) {
            var data = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetails(product: items[index]),
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
                                imageUrl: data.images[0].src,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.broken_image_rounded),
                                height: 120,
                              ),
                      
                    ),
                    Container(
                      width: 150,
                      alignment: Alignment.center,
                      child: Text(data.name,
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
                          Text('GHS ${data.price}',
                              softWrap: true,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
