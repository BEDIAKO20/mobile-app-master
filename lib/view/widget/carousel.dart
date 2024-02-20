import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CarouselSlide extends StatefulWidget {
  const CarouselSlide({Key key}) : super(key: key);

  @override
  _CarouselSlideState createState() => _CarouselSlideState();
}

class _CarouselSlideState extends State<CarouselSlide> {
  FirebaseStorage storage = FirebaseStorage.instance;

  List imageList = [];

  @override
  void initState() {
    super.initState();

    getLinks();
  }

  Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  getLinks() async {
    // var url = await storage.ref('/carousel_images').list();
    var ref = storage.ref('/carousel_images');
    var result = await ref.listAll();
  

    final urls = await _getDownloadLinks(result.items);
      print('firebase method called');
    //imageList = urls;
    setState(() {
      urls.forEach((url) {
        imageList.add(NetworkImage(url));
      });
    });

    // print('--Links--');
    // print(imageList);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //getLinks();
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(5),
        color: Colors.white,
        child: SizedBox(
          height: 170.0,
          width: screenWidth,
          child: CarouselSlider(
            items: imageList
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
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
              enlargeCenterPage: true,
              viewportFraction: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
