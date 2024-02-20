import 'package:flutter/material.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/account_base_page.dart';
import 'package:franko_mobile_app/view/widget/const.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopLocations extends AccountBasePage {
  ShopLocations({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShopLocationsState createState() => _ShopLocationsState();
}

class _ShopLocationsState extends AccountBasePageState<ShopLocations> {
  @override
  Widget pageUI(BuildContext context) {
    return _locationList();
  }

  Widget _locationList() {
    return ListView(
      children: [
        _buildCard("Adabraka", "Opposite Roxy Bus Stop Adabraka – Accra",
            "0264189099", "", ""),
        _buildCard("Accra", "UTC Near Despite Building", "0561925889", "", ""),
        _buildCard("Circle Shop 1", "Near Odo Rice Building", "0302250396",
            "0207631070", ""),
        _buildCard("Circle Shop 2", "Opposite Odo Rice Building", "0261506861",
            "", ""),
        _buildCard("Osu", "Oxford Street behind Vodafone Office", "0302772103",
            "0246663560", ""),
        _buildCard(
            "Ashiaman", "Opposite Ashiaman main Station", "0202631789", "", ""),
        _buildCard("Tema", "Community 1 Stadium Road Opposite Water Works",
            "0303214499", "0246627204", "0303214478"),
        _buildCard("Madina", "Madina Old Road Around Absa Bank, Republic Bank",
            "0241184688", "0302540646", ""),
        _buildCard(
            "Haatso",
            "Haatso Station / Beige Capital Building, Opposite Mtn",
            "0243628837",
            "0302542738",
            ""),
        _buildCard("Lapaz", "Nii Boi Junction Opposite Prudential Bank",
            "0561944202", "", ""),
        _buildCard(
            "Koforidua",
            "All Nation University Towers, Prince Boateng Roundabout",
            "0268313323",
            "0342027057",
            ""),
        _buildCard("Obuasi", "Central Mosque Opposite Adansi Rural Bank",
            "0263535131", "0322544228", ""),
        _buildCard("Kumasi Shop 1", "Opposite Hotel De Kingsway", "0322041018",
            "0245316969", ""),
        _buildCard("Kumasi Shop 2", "Aseda House Opposte Challenge Bookshop",
            "0322081949", "0245232091", ""),
        _buildCard(
            "Kumasi Shop 3", "Adjacent Melcom Adum", "0560684147", "", ""),
        _buildCard("Kumasi Shop 4", "Near Absa Bank", "0206310483", "", ""),
        _buildCard(
            "Kumasi Shop 5", "Near Kuffour Clinic", "0501538602", "", ""),
        _buildCard("Kumasi Shop 6", "Opposite Kejetia", "0501525698", "", ""),
        _buildCard("Swedru", "Opposite Melcom", "0557872937", "", ""),
        _buildCard("Ho", "Opposite Amegashi (God Is Great Building)",
            "0266363323", "0362025775", ""),
        _buildCard("Ho Annex", "Near The Ho Main Staion", "0501647165", "", ""),
        _buildCard(
            "Sunyani", "Opposite Cocoa Board", "0352025435", "0202765836", ""),
        _buildCard("Techiman", "Techiman Taxi Rank Near Republic Bank",
            "0352522426 ", "0275577500", ""),
        _buildCard("Berekum", "Berekum Roundabout Opposite Sg-SSB Bank",
            "0209835344", "0352195403", ""),
        _buildCard("Cape Coast", "London Bridge Opposite Old Guinness Depot",
            "0264212339", "0332133421", ""),
        _buildCard("Takoradi", "Cape Coast Station Near Super Star Hotel",
            "0249902589", "0312032932", ""),
        _buildCard("Tarkwa", "Tarkwa Station Near The Shell Filling Station",
            "0267207875 ", "0312320144", ""),
        _buildCard("Tamale", "Old Salaga Station Near Pk", "0265462241",
            "0372022525", ""),
        _buildCard("Hohoe", "Jahlex Store Near The Traffic Light", "0558106241",
            "", ""),
        _buildCard("Wa", "Zongo Opposite Mama’s Kitchen", "0261915228",
            "0392024475", ""),
        _buildCard("Wa Annex", "Wa Main Station", "0507316718", "", ""),
        _buildCard("Bolga", "Commercial Street Near Access Bank", "0501538603",
            "", ""),
      ],
    );
  }

  Widget _buildCard(String location, String subtitle, String phonenumber,
          String phonenumber2, String phonenumber3) =>
      Container(
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text(location,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(subtitle, style: TextStyle( color: Colors.black)),
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
