import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:franko_mobile_app/view/pages/notification/notificaction_details.dart';
import 'package:franko_mobile_app/view/pages/order/address_management.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/about_us.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/orders_page.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/service_centers_locations.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/shop_locations.dart';
import 'package:franko_mobile_app/view/view_auth/login_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'profile_menu.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DataU tokenValue;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) => {
          setState(() {
            String value = prefs.getString("token") ?? null;
            if (value != null) {
              var token = json.decode(value);
              tokenValue = DataU.fromJson(token);
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Column(
          children: [
            // ProfilePic(),
            SizedBox(height: 20),

            Container(
              child: tokenValue != null
                  ? ProfileMenu(
                      text: "My Orders",
                      icon: "assets/icons/User Icon.svg",
                      press: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersPage(
                                  title: "My Orders", orderId: tokenValue.id),
                            ))
                      },
                    )
                  : Container(),
            ),
            ProfileMenu(
              text: "Address Management",
              icon: "assets/icons/house-address.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressManagementPage(),
                    ));
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationDetailPage(title: "Notification"),
                    ));
              },
            ),
            ProfileMenu(
              text: "Shop Locations",
              icon: "assets/icons/Shop Icon.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShopLocations(title: "Shop Locations"),
                    ));
              },
            ),
            ProfileMenu(
              text: "Service Centers",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServiceCenters(title: "Service Center Locations"),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "About Us",
              icon: "assets/icons/User Icon.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(title: "About Us"),
                    ));
              },
            ),

            Container(
              child: tokenValue != null
                  ? ProfileMenu(
                      text: "Log Out",
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        _showAlertDialog();
                      },
                    )
                  : ProfileMenu(
                      text: "Log In",
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              value: "account",
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Link(
                  target: LinkTarget.self,
                  uri: Uri.parse(
                      "https://www.facebook.com/frankotradingenterprise"),
                  builder: (BuildContext context,
                      Future<void> Function() followLink) {
                    return GestureDetector(
                      onTap: followLink,
                      child: CircleAvatar(
                        child: FaIcon(FontAwesomeIcons.facebook),
                      ),
                    );
                  },
                ),
                Link(
                  target: LinkTarget.self,
                  uri: Uri.parse("https://twitter.com/frankotrading1"),
                  builder: (BuildContext context,
                      Future<void> Function() followLink) {
                    return GestureDetector(
                      onTap: followLink,
                      child: CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          child: FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          )),
                    );
                  },
                ),

                //https://twitter.com/frankotrading1
                // Link(
                //   target: LinkTarget.self,
                //   uri: Uri.parse("https://wa.me/233555939311"),
                //   builder: (BuildContext context,
                //       Future<void> Function() followLink) {
                //     return GestureDetector(
                //       onTap: followLink,
                //       child: CircleAvatar(     8uhnbbnjmjmjjm
                //           backgroundColor: Colors.green[400],
                //           child: FaIcon(
                //             FontAwesomeIcons.whatsapp,
                //             color: Colors.white,
                //           )),
                //     );
                //   },
                // ),

                Link(
                  target: LinkTarget.self,
                  uri: Uri.parse(
                      "https://www.instagram.com/frankotrading/?hl=en"),
                  builder: (BuildContext context,
                      Future<void> Function() followLink) {
                    return GestureDetector(
                      onTap: followLink,
                      child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/instabackground.jpeg"),
                          child: FaIcon(FontAwesomeIcons.instagram)),
                    );
                  },
                ),

                // Link(
                //   target: LinkTarget.defaultTarget,
                //   uri: Uri.parse("https://www.youtube.com/channel/UCMqIJuQgERgkNp0kzt7b96Q"),
                //   builder: (BuildContext context,
                //       Future<void> Function() followLink) {
                //     return GestureDetector(
                //       onTap: followLink,
                //       child: CircleAvatar(
                //        backgroundColor:Colors.red,
                //         child: FaIcon(FontAwesomeIcons.youtube,color: Colors.white,),
                //       ),
                //     );
                //   },
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
            content: Row(
              children: [Text('Are you sure you want to logout?')],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (tokenValue != null) {
                    SharedPreferences.getInstance().then((prefs) => {
                          setState(() {
                            prefs.remove("token");
                          })
                        });
                  }
                  print('logout');

                  //Navigator.of(context).pop();

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', ModalRoute.withName('/homeScreen'));
                  Navigator.of(buildContext).pop();
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                  print('close');
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }
}
