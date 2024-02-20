import 'package:flutter/cupertino.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/repositories/category_repo.dart';

class DashboardProvider with ChangeNotifier {
  CategoryRepository _categoryRepository;

  List<ProductCategory> _categoryList;
  List<ProductCategory> get categoryList => _categoryList;

  List<Products> _computerProducts;
  List<Products> get computerProducts => _computerProducts;

  List<Products> _newProducts;
  List<Products> get newProducts => _newProducts;

  List<Products> _promo;
  List<Products> get promo => _promo;

  List<Products> _mobileProducts;
  List<Products> get mobileProducts => _mobileProducts;

  bool _itemState;
  bool get itemState => _itemState;

  DashboardProvider() {
    _categoryRepository = new CategoryRepository();
    fectchCategoryList();
    // fetchHomeProducts();
  }

  fectchCategoryList() async {
    try {
      _categoryList = await _categoryRepository.getCategories();

      notifyListeners();
    } catch (e) {
      _categoryList = [];
      print(e.toString());
      notifyListeners();
    }
  }

  fetchNewProducts(String param, String paramId) async {
    try {
      _newProducts = await _categoryRepository.getProductsNew(param, paramId);
      notifyListeners();
    } catch (e) {
      print('errors');
      print(e);
      _newProducts = [];
      notifyListeners();
    }
  }

  fetchPromoProducts(String param, String paramId) async {
    try {
      _promo = await _categoryRepository.getProductsPromo(param, paramId);
      notifyListeners();
    } catch (e) {
      print('errors');
      print(e);
      _promo = [];
      notifyListeners();
    }
  }

  fetchMobileProducts(String param, String paramId) async {
    try {
      _mobileProducts =
          await _categoryRepository.getProductsMobile(param, paramId);
      notifyListeners();
    } catch (e) {
      print('errors');
      print(e);
      _mobileProducts = [];
      notifyListeners();
    }
  }

  fetchComputerProducts(String param, String paramId) async {
    try {
      _computerProducts =
          await _categoryRepository.getProductsComputer(param, paramId);
      notifyListeners();
    } catch (e) {
      print('errors');
      print(e);
      _computerProducts = [];
      notifyListeners();
    }
  }
}
