class Cart {
  int id;
  int quantity;
  double price;
  double total;
  String name;
  String image;

  Cart({this.id, this.quantity, this.price, this.total, this.name, this.image});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
    data['name'] = this.name;
    data['image'] = this.image;
    
    return data;
  }

  @override
  toString() => this.toJson().toString();
}
