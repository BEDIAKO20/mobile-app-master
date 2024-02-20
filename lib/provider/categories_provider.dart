import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';



enum LoadMore {INITIAL, LOADING, STABLE }


class CategoriesProvider with ChangeNotifier{
  APIService _apiService;
  List<Products> _productList;
  
  

  int pageSize = 10;
  String status = "publish";

  List<Products> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  

  LoadMore _loadMoreStatus = LoadMore.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  CategoriesProvider() {
    resetStreams();
  }

  void resetStreams() {
    _apiService = APIService();
    _productList = List<Products>();
  }

  setLoadingState(LoadMore loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  fetchProducts(pageNumber,{
    String strSearch,
    String tagName,
    String categoryId,
    String sortOrder, 
    String status
  }) async {
    List<Products> itemModel = await _apiService.getProductBrands(
      strSearch: strSearch,
      tagName: tagName,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      categoryId: categoryId,
      status: this.status,
    );

    if(itemModel.length > 0 ) {
      _productList.addAll(itemModel);
    }
    //print("ddddd");
    setLoadingState(LoadMore.STABLE);
    notifyListeners();
  }

  
}