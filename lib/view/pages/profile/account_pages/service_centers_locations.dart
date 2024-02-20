import 'package:flutter/material.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/account_base_page.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCenters extends AccountBasePage {
  ServiceCenters({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ServiceCentersState createState() => _ServiceCentersState();
}

class _ServiceCentersState extends AccountBasePageState<ServiceCenters> {
  @override
  Widget pageUI(BuildContext context) {
    return _locationList();
  }

  Widget _locationList() {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            navigateTo("https://www.google.com/maps/place/5%C2%B034'24.2%22N+0%C2%B012'54.4%22W/@5.5733754,-0.2172915,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0xd310613fbf4f4a4b!8m2!3d5.5733754!4d-0.2151028?hl=en");
          },
          child: _buildCard(
              "Circle Service Center", "Near Odo Rice", "0501575745", "", ""),
        ),
        GestureDetector(
          onTap: () {
            navigateTo("");
          },
          child: _buildCard("Kumasi Service Center",
              "Adum Behind The Old Melcom Building", "0501575746", "", ""),
        ),
        GestureDetector(
          onTap: () {
            navigateTo(
                "https://www.google.com/maps/place/9%C2%B024'13.8%22N+0%C2%B050'27.8%22W/@9.4038239,-0.8432299,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x999b8bdc087d757a!8m2!3d9.4038239!4d-0.8410412?hl=en");
          },
          child: _buildCard(
              "Tamale Service Center",
              "Adjacent Quality First Shopping Center",
              "0501505020",
              "0501648030",
              ""),
        ),
      ],
    );
  }

  static void navigateTo(String url) async {
    var uri = Uri.parse(
        url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }

    //  static void navigateTo(double lat, double lng) async {
    //  var uri = Uri.parse("https://www.google.com/maps/place/Christmas+%F0%9F%8E%84/@$lat,$lng,18z/data=!4m22!1m16!4m15!1m6!1m2!1s0xfdf90a7a8d827a1:0x7c9380bfa48a343c!2sKwame+Nkrumah+Ave,+Accra!2m2!1d-0.2119593!2d5.5560681!1m6!1m2!1s0xfdf9a1aa766988b:0x9a040edb68184ea7!2zQ2hyaXN0bWFzIPCfjoQsIENpcmNsZSwgQWNjcmE!2m2!1d-0.1855954!2d5.6091716!3e0!3m4!1s0xfdf9a1aa766988b:0x9a040edb68184ea7!8m2!3d5.6091716!4d-0.1855954");
    //  if (await canLaunch(uri.toString())) {
    //     await launch(uri.toString());
    //  } else {
    //     throw 'Could not launch ${uri.toString()}';
    //  }
  }

  Widget _buildCard(String location, String subtitle, String phonenumber,
          String phonenumber2, String phonenumber3) =>
      Container(
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text(location,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                subtitle: Text(subtitle, style: TextStyle(color: Colors.black)),
                leading: Icon(
                  Icons.location_city,
                  color: kPrimaryColor,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () => _makingPhoneCall(phonenumber),
                title: Text(phonenumber,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                leading: Icon(
                  Icons.phone,
                  color: kPrimaryColor,
                ),
              ),
              phonenumber2 == ""
                  ? new Container()
                  : ListTile(
                      onTap: () => _makingPhoneCall(phonenumber2),
                      title: Text(phonenumber2,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      leading: Icon(
                        Icons.phone,
                        color: kPrimaryColor,
                      ),
                    ),
              phonenumber3 == ""
                  ? new Container()
                  : ListTile(
                      onTap: () => _makingPhoneCall(phonenumber3),
                      title: Text(phonenumber3,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      leading: Icon(
                        Icons.phone,
                        color: kPrimaryColor,
                      ),
                    ),
            ],
          ),
        ),
      );

  _makingPhoneCall(String number) async {
    var url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
