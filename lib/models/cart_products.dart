class CartProduct{
  String productId;
  int quantity;

  CartProduct({
    this.productId,
    this.quantity
  });

  CartProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    return data;
  }

   @override toString() => this.toJson().toString();

}

