class CartRequestModel {
  List<CartProducts> products;

  CartRequestModel({this.products});

  CartRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      List<CartProducts> products;

      json['products'].forEach((v) {
        products.add(new CartProducts.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if(this.products != null) {
  //     data['products'] = this.products.map((v) => v.toJson());
  //   }
  //   return data;
  // }

}

class CartProducts {
  String productId;
  String quantity;

  CartProducts({this.productId, this.quantity});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }

  @override
  toString() => this.toJson().toString();
}
