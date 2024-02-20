class CardPay {
  TKKPG tKKPG;

  CardPay({this.tKKPG});

  CardPay.fromJson(Map<String, dynamic> json) {
    tKKPG = json['TKKPG'] != null ? new TKKPG.fromJson(json['TKKPG']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tKKPG != null) {
      data['TKKPG'] = this.tKKPG.toJson();
    }
    return data;
  }
}

class TKKPG {
  Request request;

  TKKPG({this.request});

  TKKPG.fromJson(Map<String, dynamic> json) {
    request =
        json['Request'] != null ? new Request.fromJson(json['Request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.request != null) {
      data['Request'] = this.request.toJson();
    }
    return data;
  }
}

class Request {
  String operation;
  String language;
  Order order;

  Request({this.operation, this.language, this.order});

  Request.fromJson(Map<String, dynamic> json) {
    operation = json['Operation'];
    language = json['Language'];
    order = json['Order'] != null ? new Order.fromJson(json['Order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Operation'] = this.operation;
    data['Language'] = this.language;
    if (this.order != null) {
      data['Order'] = this.order.toJson();
    }
    return data;
  }
}

class Order {
  String merchant;
  String amount;
  String currency;
  String description;
  String approveURL;
  String cancelURL;
  String declineURL;
  String orderType;

  Order(
      {this.merchant,
      this.amount,
      this.currency,
      this.description,
      this.approveURL,
      this.cancelURL,
      this.declineURL,
      this.orderType});

  Order.fromJson(Map<String, dynamic> json) {
    merchant = json['Merchant'];
    amount = json['Amount'];
    currency = json['Currency'];
    description = json['Description'];
    approveURL = json['ApproveURL'];
    cancelURL = json['CancelURL'];
    declineURL = json['DeclineURL'];
    orderType = json['OrderType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Merchant'] = this.merchant;
    data['Amount'] = this.amount;
    data['Currency'] = this.currency;
    data['Description'] = this.description;
    data['ApproveURL'] = this.approveURL;
    data['CancelURL'] = this.cancelURL;
    data['DeclineURL'] = this.declineURL;
    data['OrderType'] = this.orderType;
    return data;
  }
}