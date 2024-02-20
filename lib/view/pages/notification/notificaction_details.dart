import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/provider/dashboard_provider.dart';
import 'package:franko_mobile_app/repositories/category_repo.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';
import 'package:franko_mobile_app/view/widget/const.dart';



import '../../../config.dart';


class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({Key key, this.title, this.body, this.image})
      : super(key: key);
  final String title;
  final String body;
  final String image;

  @override
  _NotificationDetailPageState createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  String noteBody;
  String noteImage;
  String noteTitle;
  DashboardProvider promoData;
  List<Products> _promoItems = [];
  // List<Products> products;

  Future<List<Products>> future;

  CategoryRepository _categoryRepository = new CategoryRepository();
  // List<Products> _promo = [];

  String imageSrc =
      "https://firebasestorage.googleapis.com/v0/b/franko-trading-app.appspot.com/o/WhatsApp%20Image%202021-11-01%20at%2011.56.29%20AM.jpeg?alt=media&token=15c6722c-a993-4ecc-9ebd-52b23eee8a63";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    future = _getUsersPromo();
  }

  Future<List<Products>> _getUsersPromo() async {
    _promoItems = await _categoryRepository.getProductsPromo(
        Config.tagParam, Config.promoId);

    print('something');
    print(_promoItems);

    return _promoItems;
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) print(arguments['noteBody'] + "  note detail page");

    if (arguments != null) {
      noteTitle = arguments['noteTitle'];
      noteBody = arguments['noteBody'];
      noteImage = arguments['noteImage'];
    }
    // if (widget.title != null) {
    //   noteTitle = widget.title;
    //   noteBody = widget.body;
    //   noteImage = widget.image;
    // }

    // print("note Detail");
    // print(noteBody);
    // print(noteTitle);

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 1,
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: Colors.transparent,
      //   iconTheme: IconThemeData(color: Colors.black),
      //   automaticallyImplyLeading: true,
      //   title: Text(
      //     "Notification",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.search),
      //         onPressed: () {
      //           showSearch(context: context, delegate: ProductSearch());
      //         },
      //         color: Colors.black),
      //     // _shoppingCartBadge(),
      //   ],
      // ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              stretch: false,
              backgroundColor: Colors.teal[300],
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // stretchModes: [StretchMode.blurBackground],
                //collapseMode:CollapseMode.pin,
                background: SvgPicture.asset(
                  "assets/icons/discount.svg",
                  // width: size.width * 0.4,
                  // color: Colors.grey,
                ),
                // Image.network(
                //   noteImage ?? imageSrc,
                //   fit: BoxFit.cover,
                // ),
                title: Text("Promotions"),
                centerTitle: true,
              ),
              // leading: Icon(Icons.arrow_back),
              automaticallyImplyLeading: true,
            ),
            buildFlashGrid(),
          ],
        ),
      ),
    );
  }

  Widget buildFlashGrid() {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(child: Center(child: Text("Empty")));
          }

          if (!snapshot.hasData) {
            return Container(
              child: Center(child: Text("LOADING")),
            );
          }
          // print("priniting");
          // print(snapshot.data);
          return gridBuilderMethod(snapshot.data);
        },
      ),
    );
  }

  GridView gridBuilderMethod(List<Products> promoProducts) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,

      //items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // childAspectRatio: 3 / 2,
        // crossAxisSpacing: 20,
        // mainAxisSpacing: 20
      ),
      primary: false,
      shrinkWrap: true,
      itemCount: promoProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // print(product);
            // print('-new widget product -');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetails(product: promoProducts[index]),
                ));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.2,
                ),
              ),
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
                    imageUrl: promoProducts[index].images[0].src ??
                        "https://cdn.icon-icons.com/icons2/1369/PNG/512/-broken-image_89881.png",
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 150,
                  ),
                ),
                Container(
                  width: 150,
                  alignment: Alignment.center,
                  child: Text(promoProducts[index].name,
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
                      Text('GHS ${promoProducts[index].price}',
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
      },
    );
  }
}
