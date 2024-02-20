class ProductCategory {
   int categoryId;
   String categoryName;
   String categoryDesc;
   int parent;
   ImageUrl image;

  ProductCategory ({
    this.categoryId,
    this.categoryName,
    this.categoryDesc,
    this.parent,
    this.image,
  });

  ProductCategory.fromJson(Map<String, dynamic>json){
    categoryId   = json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent       = json['parent'];
    image        = json['image'] != null ? new ImageUrl.fromJson(json['image']) : null; 
  }

}


class ImageUrl {
  String url;

  ImageUrl({
    this.url,
  });

  ImageUrl.fromJson(Map<String, dynamic>json) {
    url= json['src'];
  }

}