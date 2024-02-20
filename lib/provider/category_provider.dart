import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/category.dart';
import 'package:franko_mobile_app/repositories/category_repo.dart';

class CategoryProvider with ChangeNotifier {
  CategoryRepository _categoryRepository;

  List<ProductCategory> _categoryList;
  List<ProductCategory> get categoryList => _categoryList;
  Future<List<ProductCategory>> get categoryLists => _categoryList as Future;

  List<ProductCategory> _brandList;
  List<ProductCategory> get brandList => _brandList;
  Future<List<ProductCategory>> get brandLists => _brandList as Future;

  CategoryProvider() {
    _categoryRepository = new CategoryRepository();
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

  fectchBrandList(int categoryId) async {
    try {
      _brandList = await _categoryRepository.getbrands(categoryId);

      notifyListeners();
    } catch (e) {
      _brandList = [];
      print(e.toString());
      notifyListeners();
    }
  }
}
