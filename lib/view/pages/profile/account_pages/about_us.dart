import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/view/pages/profile/account_pages/account_base_page.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUs extends AccountBasePage {
  AboutUs({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends AccountBasePageState<AboutUs> {
  @override
  Widget pageUI(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Who we are",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '''Franko Trading Enterprise is the Leading retail and wholesale company of Mobile phones, Computers, Laptops, Televisions, Accessories etc.
The Company is amongst the first to bring in modern technological gadgets into Ghana since its establishment in 2004 with earlier branches in Kumasi & Accra.
The Head Office is currently located at Adabraka Opposite Roxy Cinema in Accra.
Our company provides the best devices and products at affordable prices for Ghanaians to afford. Due to this, we are known as ‘Phone papa Fie’, which translates as Home of Quality Phones.
''',
                ),
                SizedBox(height: 10),
                Text(
                  "Branches & Reach",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                    '''Since its establishment in 2004, the company has expanded its reach (33 Branches) to almost all regions and parts of the country including rural and urban centers of trade. 
In order to give affordable and quality products to our consumers, these branches have been stocked with products as well as top notch employees who are experienced with our products. The various branches have been strategically placed for easier directions and accessibility for customers. We aspire to provide quality devices as well as quality customer care.
'''),
                SizedBox(height: 10),
                Text(
                  "Devices & Products",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                    '''Franko Trading enterprise has come a long way in provision of mobile phones such as Nokia, Apple Iphones, Samsung, Alcatel, Infinix, Tecno, Huawei, Itel, Xtigi, Viwa, etc.
We also sell popular laptop brands such as Hp, Dell, Apple MacBook, Avita, Toshiba, Lenovo, Asus Desktops etc.
 We also have Asano Home Theaters, Smart watches, Bluetooth speakers, Mobile Phone Accessories, Flatscreen LED Televisions such as Asano, Skyworth, Samsung etc.
The Company has branched into provision of its own branded products and have started with the Franko Television in various sizes. Since the launch of the Franko TV, it has experienced great success and popularity on the Ghanaian market due its refined Display quality, Durability and Affordability.
'''),
                SizedBox(height: 10),
                Text(
                  "Online Shopping",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(height: 5),
                  RichText(text: TextSpan(
            children: [
              TextSpan(
                style: TextStyle(color: Colors.black),
                text: "Our quest for better service to the millennial Ghanaian consumer cannot be overstated. Franko Trading Enterprise is synonymous in the aspects of Pioneering online shopping platforms in Ghana. We do have a full functioning App and Website where customer can place orders and have them delivered at the various locations in Ghana. Visit our website (www.frankotrading.com), App( https://play..com/store/apps/developer...) and all social media platforms",
              ),
              TextSpan(
                style:  TextStyle(color: Colors.black),
                text:'@frankotrading',
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url = 'https://frankotrading.com/';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                      );
                    }
                  },
              ),
              // TextSpan( 
              //   style: bodyTextStyle,
              //   text: seeSourceSecond,
              // ),
            ]),)
                
//                  Text('''Our quest for better service to the millennial Ghanaian consumer cannot be overstated. Franko Trading Enterprise is synonymous in the aspects of Pioneering online shopping platforms in Ghana. We do have a full functioning App and Website where customer can place orders and have them delivered at the various locations in Ghana. 
// Visit our website (www.frankotrading.com), App( https://play..com/store/apps/developer...) and all social media platforms @frankotrading.
// '''),


              ]),
        ),
      ),
    );
  }
}
