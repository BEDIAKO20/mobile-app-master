import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key key,
    this.data,
  }) : super(key: key);

  final Products data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(
                product: data,
              ),
            ));
      },
      child: Container(
          decoration: BoxDecoration(color: Colors.white,
              //borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xff8f8f8),
                  blurRadius: 15,
                  spreadRadius: 10,
                )
              ]),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          // CircleAvatar(
                          //   radius: 30,
                          //   backgroundColor: Color(0xffE65829),
                          // ),
                          CachedNetworkImage(
                            imageUrl: data.images[0].src,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.broken_image_rounded),
                            height: 150,
                          ),
                          // Image(
                          //   image: CachedNetworkImageProvider(

                          //   ),
                          //   data.images.length > 0 ? data.images[0].src : "",
                          //   height: 150,
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.name,
                      // textScaleFactor: 0.85,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: data.salePrice != data.regularPrice,
                          child: Text(
                            'GHS${data.regularPrice}',
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'GHS ${data.price}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
