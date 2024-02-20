import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/config.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/pages/product/product_details.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {
  APIService apiService = APIService();

  static Future<String> createDynamicLink(bool short, Products product) async {
    String _linkMessage;
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://frankotrading.page.link',

      //Config url - is basically base url
      //Config product url - is basically /products

      link: Uri.parse(Config.url +
          Config.productURL +
          '${product.id}?consumer_key=${Config.key}&consumer_secret=${Config.secret}'),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse('https://frankotrading.com/'),
        packageName: 'com.frakotg.enterapp',
        // minimumVersion: 125,
      ),
      iosParameters: IOSParameters(
        fallbackUrl: Uri.parse('https://frankotrading.com/'),
        appStoreId: '1465342117',
        bundleId: 'com.frankotrading.frankotrading',
        minimumVersion: '1.0.1',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
      //display some type of error
    }
    print(product.id);

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    // FirebaseDynamicLinks.instance.onLink;

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    try {
      final Uri deepLink = data.link;
      //change the storydata to something unique
      var isProduct = deepLink.pathSegments.contains('frankoData');
      if (isProduct) {
        // TODO :Modify Accordingly
        String id = deepLink.queryParameters['id']; // TODO :Modify Accordingly

        // use id to find product

        var productData = await APIService().getproduct(id);

        Products product = productData;

        print(product);

        // TODO : Navigate to your pages accordingly here

        FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
          // Navigator.pushNamed(context, dynamicLinkData.link.path);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(product: product)));
        }).onError((error) {
          // Handle errors
          print(error);
        }); /*  */
        //420019
        //product-6420
      }
    } catch (e) {
      print('No deepLink found');
    }
  }
}
