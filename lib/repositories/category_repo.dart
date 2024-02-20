import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/models/category.dart';


class CategoryRepository {
  APIService apiService = APIService();

  Future<List<ProductCategory>> getCategories() async {
    final categoryData = await APIService().getCategories();
    
    return categoryData;
  }

  Future<List<Products>> getProductsNew(String param, String paramId) async {
    final homeProductsData = await APIService().getProductsHome(param, paramId);
    return homeProductsData;
  }

  Future<List<Products>> getProductsPromo(String param, String paramId) async {
    final homeProductsData = await APIService().getProductsHome(param, paramId);
    return homeProductsData;
  }

  Future<List<Products>> getProductsMobile(String param, String paramId) async {
    final homeProductsData = await APIService().getProductsHome(param, paramId);
    return homeProductsData;
  }

  Future<List<Products>> getProductsComputer(
      String param, String paramId) async {
    final homeProductsData = await APIService().getProductsHome(param, paramId);
    return homeProductsData;
  }

  Future<List<ProductCategory>> getbrands(int categoryId) async {
    final brands = await apiService.getbrands(categoryId);
    return brands;
  }  
}
