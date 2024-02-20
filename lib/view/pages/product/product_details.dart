import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/product_model.dart';
import 'package:franko_mobile_app/models/variable_product_model.dart';
import 'package:franko_mobile_app/services/api_service.dart';
import 'package:franko_mobile_app/view/widget/base_page.dart';
import 'package:franko_mobile_app/view/widget/widget_product_details.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key key, this.product, this.quantity}) : super(key: key);

  final Products product;
   int quantity;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  
  APIService apiService;

  @override
  initState() {
    this.widget.quantity = 1;
    super.initState();
    print(this.widget.product.id);
  }
  @override
 Widget pageUI() {
    return this.widget.product.type == "variable" ? _variableProductList() : ProductDetailsWidget(data: this.widget.product, quantity: this.widget.quantity );
  }

  Widget _variableProductList(){
    apiService = new APIService();
    return new FutureBuilder(
      future: apiService.getVariableProduct(this.widget.product.id),
      builder: (BuildContext context, AsyncSnapshot<List<VariableProduct>> model){
        if(model.hasData){
          return ProductDetailsWidget(data: this.widget.product, variableProducts: model.data);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}
