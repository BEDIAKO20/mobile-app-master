class CartResponseModel {
  String key;
  int productId;
  int variationId;
  int quantity;
  String dataHash;
  int lineSubtotal;
  int lineSubtotalTax;
  int lineTotal;
  int lineTax;
  String productName;
  String productTitle;
  String productPrice;

  CartResponseModel(
      {this.key,
      this.productId,
      this.variationId,
      this.quantity,
      this.dataHash,
      this.lineSubtotal,
      this.lineSubtotalTax,
      this.lineTotal,
      this.lineTax,
      this.productName,
      this.productTitle,
      this.productPrice});

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    dataHash = json['data_hash'];
    lineSubtotal = json['line_subtotal'];
    lineSubtotalTax = json['line_subtotal_tax'];
    lineTotal = json['line_total'];
    lineTax = json['line_tax'];
    productName = json['product_name'];
    productTitle = json['product_title'];
    productPrice = json['product_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['product_id'] = this.productId;
    data['variation_id'] = this.variationId;
    data['quantity'] = this.quantity;
    data['data_hash'] = this.dataHash;
    data['line_subtotal'] = this.lineSubtotal;
    data['line_subtotal_tax'] = this.lineSubtotalTax;
    data['line_total'] = this.lineTotal;
    data['line_tax'] = this.lineTax;
    data['product_name'] = this.productName;
    data['product_title'] = this.productTitle;
    data['product_price'] = this.productPrice;
    return data;
  }
}




// class CartResponseModel {
//   List<CartItem> data;

//   CartResponseModel({
//     this.data,
//   });

//   CartResponseModel.fromJson(Map<String, dynamic> json) {
//     if(json['data']) {
//       data = new List<CartItem>();
//       json['data'].forEach((v) {
//         data.add(new CartItem.fromJson(v));
//       });
//     }
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if(this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class CartItem {
//   int productId;
//   String productName;
//   String productPrice;
//   String thumbnail;
//   int quantity;
//   double lineSubtotal;
//   double lineTotal;

//   CartItem({
//     this.productId,
//     this.productName,
//     this.productPrice,
//     this.thumbnail,
//     this.quantity,
//     this.lineSubtotal,
//     this.lineTotal,
//   });

//   CartItem.fromJson(Map<String, dynamic> json){
//     productId = json['product_id'];
//     productName = json['product_name'];
//     productPrice = json['product_price'];
//     thumbnail = json['thumbnail'];
//     quantity = json['quantity'];
//     lineSubtotal = double.parse(json['line_subtotal'].toString());
//     lineTotal = double.parse(json['line_total'].toString());
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['product_name'] = this.productName;
//     data['product_price'] = this.productPrice;
//     data['thumbnail'] = this.thumbnail;
//     data['quantity'] = this.quantity;
//     data['line_subtotal'] = this.lineSubtotal;
//     data['line_total'] = this.lineTotal;
//     return data;
//   }
// }