import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({Key key}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  List imageList;
  String imageLink1 =
      'https://firebasestorage.googleapis.com/v0/b/franko-trading-app.appspot.com/o/carousel_images%2Fdelivery%20.jpg?alt=media&token=dac9cfd8-3b31-4234-84e4-b667baaf9cdf';
  String imageLink2 =
      'https://firebasestorage.googleapis.com/v0/b/franko-trading-app.appspot.com/o/carousel_images%2FDesktop-nd-Tablet_1.jpg?alt=media&token=9d7e04e6-3fdf-48c3-97e4-8d8d1f2664c3';
  String imageLink3 =
      'https://firebasestorage.googleapis.com/v0/b/franko-trading-app.appspot.com/o/carousel_images%2Ffranko_mtn%20merchant%20code.jpg?alt=media&token=7849eabe-424c-408e-a950-ec390ef666c5';




@override
  void initState() {
    // TODO: implement initState
    super.initState();

    imageList = [
      NetworkImage(imageLink1),
      NetworkImage(imageLink2),
      NetworkImage(imageLink3),
    ];
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(5),
      // color: Colors.white,
      child: SizedBox(
        height: 200.0,
        width: screenWidth,
        child: CarouselSlider(
          items: imageList
              .map(
                (item) => Container(
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(
                       
                        image:  DecorationImage(
                    image: item,
                    fit: BoxFit.fill,
                  ),
                      ),
                  width: screenWidth,
                  
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            autoPlayCurve: Curves.easeInExpo,
            viewportFraction: 0.9,
          ),
        ),
      ),
    );
  }
}
