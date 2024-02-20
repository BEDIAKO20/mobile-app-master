import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  APIService _apiService;
  List<Products> _productList;
  SortBy _sortBy;

  int pageSize = 10;
  String status = "publish";

  List<Products> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _productList = List<Products>();
  }

  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  fetchProducts(pageNumber,
      {String strSearch,
      String tagName,
      String categoryId,
      String sortOrder,
      String status}) async {
    List<Products> itemModel = await _apiService.getProducts(
      strSearch: strSearch,
      tagName: tagName,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      categoryId: categoryId,
      status: this.status,
      sortOrder: this._sortBy.sortOrder,
    );

    if (itemModel.length > 0) {
      _productList.addAll(itemModel);

      print("printing product category");
      // itemModel.forEach((element) {
      //   print(element.name);
      // });
    }
    //print("ddddd");
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }
}



