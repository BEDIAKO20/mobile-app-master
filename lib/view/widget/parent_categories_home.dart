import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:franko_mobile_app/repositories/category_repo.dart';
import 'package:franko_mobile_app/view/pages/product/product_page.dart';
import 'package:franko_mobile_app/provider/dashboard_provider.dart';


class ParentCategories extends StatelessWidget {
  List<ProductCategory> categories = [];
  DashboardProvider dashboardProvider = DashboardProvider();
  CategoryRepository _categoryRepository = new CategoryRepository();
  @override
  Widget build(BuildContext context) {
    //final _apiService = APIService();
    //var screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(
        top: 3,
      ),
      child: Card(
        elevation: 2,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 10),
                    child: Text(
                      "Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
      
              _buildCategoryList(context)
              // _categoriesList(_apiService)
            ],
          ),
        ),
      ),
    );
  }

  // Widget _categoriesList(api) {
  //   //final _apiService = useMemoized(() => APIService());
  //   return FutureBuilder(
  //       future: api.getCategories(),
  //       builder: (
  //         BuildContext context,
  //         model,
  //       ) {
  //         if (model.hasData) {
  //           return _buildCategoryList(
  //               // model.data,
  //               context);
  //         }
  //         if (!model.hasData) {
  //           // print('no data');
  //           return Container();
  //         }
  //         return Center(
  //           child: CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
  //           ),
  //         );
  //       });
  // }

  Widget _buildCategoryList(
      // List<ProductCategory> categories,
      BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: FutureBuilder(
          future: _categoryRepository.getCategories(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ProductCategory>> categoryData,
          ) {
            // categoryData.fectchCategoryList();
            categories = categoryData.data;
            // print(categories);
            // print('categories');
            if (categories == null) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var data = categories[index];

                // print('categories parent categories');
                // print(data.categoryId);

                // if (data == null) {
                //   return Row();
                // }
                // print(data.categoryName.toString() + 'hi');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductPage(
                                categoryId: data.categoryId.toString(),
                                categoryName: data.categoryName),),);
                  },
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl: data.image.url,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.broken_image_rounded),
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 1, 5, 1),
                            child: Row(
                              children: [
                                Text(
                                  data.categoryName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Icon(
                                //   Icons.keyboard_arrow_right,
                                //   size: 14,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
