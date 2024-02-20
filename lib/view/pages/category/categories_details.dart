
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:franko_mobile_app/view/widget/widget_search_bar.dart';

class CategoryDetails extends StatefulWidget {
  CategoryDetails({Key key, this.categoryId, this.categoryName})
      : super(key: key);

  final String categoryName;
  final int categoryId;

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  APIService apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _brandsList();
  }

  Widget _brandsList() {
    return FutureBuilder(
      future: apiService.getbrands(this.widget.categoryId),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductCategory>> model) {
        if (model.hasData) {
          return _brandsTab(model.data);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _brandsTab(brands) {
    return DefaultTabController(
      length: brands.length,
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            centerTitle: true,
            bottomOpacity: 1.0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            automaticallyImplyLeading: true,
            title: Text(
              //'Franko Trading',
              this.widget.categoryName,
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                     showSearch(context: context, delegate: ProductSearch());
                  },
                  color: Colors.black),
              IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                  color: Colors.black),
            ],
            bottom: TabBar(
              labelPadding: EdgeInsets.all(15),
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              labelColor: Colors.black87,
              indicator: UnderlineTabIndicator(),
              labelStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.black45,
              unselectedLabelStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              tabs: List<Widget>.generate(
                  brands.length, (index) => Text(brands[index].categoryName)),
            ),
          ),
          body: TabBarView(
              children: List.generate(brands.length, (index) {
            return ListView.builder(
              itemCount: brands.length,
              itemBuilder: (context, index) {
                return Center(
                    child: Text(brands[index](0).categoryId.toString()));
              },
            );
          })
        )),
    );
  }

}
