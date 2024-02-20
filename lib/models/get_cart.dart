class GetCart {
  String currency;
  String cartKey;
  String cartHash;
  List<Items> items;
  int itemCount;
  bool needsShipping;
  bool needsPayment;
  Totals totals;

  GetCart(
      {this.currency,
      this.cartKey,
      this.cartHash,
      this.items,
      this.itemCount,
      this.needsShipping,
      this.needsPayment,
      this.totals});

  GetCart.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    cartKey = json['cart_key'];
    cartHash = json['cart_hash'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    itemCount = json['item_count'];
    needsShipping = json['needs_shipping'];
    needsPayment = json['needs_payment'];
    totals =
        json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['cart_key'] = this.cartKey;
    data['cart_hash'] = this.cartHash;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['item_count'] = this.itemCount;
    data['needs_shipping'] = this.needsShipping;
    data['needs_payment'] = this.needsPayment;
    if (this.totals != null) {
      data['totals'] = this.totals.toJson();
    }
    return data;
  }
}

class Items {
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
  String productImage;
  String slug;
  String productType;
  String priceRaw;
  String price;
  String linePrice;
  StockStatus stockStatus;
  int minPurchaseQuantity;
  int maxPurchaseQuantity;

  Items(
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
      this.productPrice,
      this.productImage,
      this.slug,
      this.productType,
      this.priceRaw,
      this.price,
      this.linePrice,
      this.stockStatus,
      this.minPurchaseQuantity,
      this.maxPurchaseQuantity});

  Items.fromJson(Map<String, dynamic> json) {
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
    productImage = json['product_image'];
    slug = json['slug'];
    productType = json['product_type'];
    priceRaw = json['price_raw'];
    price = json['price'];
    linePrice = json['line_price'];
    stockStatus = json['stock_status'] != null
        ? new StockStatus.fromJson(json['stock_status'])
        : null;
    minPurchaseQuantity = json['min_purchase_quantity'];
    maxPurchaseQuantity = json['max_purchase_quantity'];
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
    data['product_image'] = this.productImage;
    data['slug'] = this.slug;
    data['product_type'] = this.productType;
    data['price_raw'] = this.priceRaw;
    data['price'] = this.price;
    data['line_price'] = this.linePrice;
    if (this.stockStatus != null) {
      data['stock_status'] = this.stockStatus.toJson();
    }
    data['min_purchase_quantity'] = this.minPurchaseQuantity;
    data['max_purchase_quantity'] = this.maxPurchaseQuantity;
    return data;
  }

   @override toString() => this.toJson().toString();
}

class StockStatus {
  String status;
  int stockQuantity;
  String hexColor;

  StockStatus({this.status, this.stockQuantity, this.hexColor});

  StockStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    stockQuantity = json['stock_quantity'];
    hexColor = json['hex_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['stock_quantity'] = this.stockQuantity;
    data['hex_color'] = this.hexColor;
    return data;
  }
}

class Totals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  String shippingTax;
  String discountTotal;
  String discountTax;
  String cartContentsTotal;
  String cartContentsTax;
  String feeTotal;
  String feeTax;
  String total;
  String totalTax;

  Totals(
      {this.subtotal,
      this.subtotalTax,
      this.shippingTotal,
      this.shippingTax,
      this.discountTotal,
      this.discountTax,
      this.cartContentsTotal,
      this.cartContentsTax,
      this.feeTotal,
      this.feeTax,
      this.total,
      this.totalTax});

  Totals.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    subtotalTax = json['subtotal_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    discountTotal = json['discount_total'];
    discountTax = json['discount_tax'];
    cartContentsTotal = json['cart_contents_total'];
    cartContentsTax = json['cart_contents_tax'];
    feeTotal = json['fee_total'];
    feeTax = json['fee_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['subtotal_tax'] = this.subtotalTax;
    data['shipping_total'] = this.shippingTotal;
    data['shipping_tax'] = this.shippingTax;
    data['discount_total'] = this.discountTotal;
    data['discount_tax'] = this.discountTax;
    data['cart_contents_total'] = this.cartContentsTotal;
    data['cart_contents_tax'] = this.cartContentsTax;
    data['fee_total'] = this.feeTotal;
    data['fee_tax'] = this.feeTax;
    data['total'] = this.total;
    data['total_tax'] = this.totalTax;
    return data;
  }
}
