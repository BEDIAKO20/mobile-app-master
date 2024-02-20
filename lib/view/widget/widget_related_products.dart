import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';
import 'package:franko_mobile_app/view/widget/const.dart';

class RelatedProducts extends StatefulWidget {
  RelatedProducts(
      {Key key, this.labelname, this.product, this.productId, this.data})
      : super(key: key);

  String labelname;
  List<int> product;
  String productId;

  Products data;

  @override
  _RelatedProductsState createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.widget.labelname,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(right: 16, top: 0),
                  child: Text(
                    "",
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ),
                Divider(),
              ],
            ),
            _categoriesList()
          ],
        ),
      ),
    );
  }

  Widget _categoriesList() {
    return new FutureBuilder(
        future: apiService.getProducts(relatedIds: this.widget.product),
        builder: (
          BuildContext context,
          model,
        ) {
          if (model.hasData) {
            return _buildCategoryList(model.data);
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        });
  }

  Widget _buildCategoryList(product) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: product.length,
        itemBuilder: (context, index) {
          var data = product[index];
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductDetails(product: product[index])));
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: data.images[0].src,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 100,
                    ),
                    // Image.network(
                    //   data.images[0].src,
                    //   height: 100,
                    // ),
                  ),
                  Container(
                    width: 150,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: Text(
                        data.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 0.8,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}