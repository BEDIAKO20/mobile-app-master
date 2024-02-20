class Products {
  int id;
  int quantity;
  String name;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  List<Images> images;
  List<Categories> categories;
  List<int> relatedIds;
  String shippingAddressFee;
  String shippingAddressLocation;
   String type;

  Products(
      {this.id,
      this.name,
      this.description,
      this.shortDescription,
      this.sku,
      this.price,
      this.regularPrice,
      this.salePrice,
      this.stockStatus,
      this.relatedIds,
      this.quantity,
      this.type,
      this.shippingAddressFee,
      this.shippingAddressLocation});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['shortDescription'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regularPrice'];
    salePrice = json['salePrice'];
    stockStatus = json['stock_status'];
    relatedIds = json['related_ids'].cast<int>();
    type = json['type'];

    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }

    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  String get noteBody => null;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;

    data['stock_status'] = this.stockStatus;

    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }

    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }

    return data;
  }

  bool isSameAs(Products item) {
    return this.id == item.id;
  }
}

class Categories {
  int id;
  String name;
  Categories({
    this.id,
    this.name,
  });
  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Images {
  String src;
  Images({
    this.src,
  });


  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['src'] = this.src;

    return data;
  }

  @override
  toString() => this.toJson().toString();
}
