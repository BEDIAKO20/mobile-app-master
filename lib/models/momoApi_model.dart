class MomoApi {
  String code;
  Data data;
  String msg;

  MomoApi({this.code, this.data, this.msg});

  MomoApi.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  double amount;
  String countryShortName;
  String currency;
  String custCountry;
  String custEmail;
  String custFirstname;
  String custLastname;
  String custPhone;
  Links links;
  String orderId;

  Data(
      {this.amount,
      this.countryShortName,
      this.currency,
      this.custCountry,
      this.custEmail,
      this.custFirstname,
      this.custLastname,
      this.custPhone,
      this.links,
      this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    countryShortName = json['countryShortName'];
    currency = json['currency'];
    custCountry = json['cust_country'];
    custEmail = json['cust_email'];
    custFirstname = json['cust_firstname'];
    custLastname = json['cust_lastname'];
    custPhone = json['cust_phone'];
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['countryShortName'] = this.countryShortName;
    data['currency'] = this.currency;
    data['cust_country'] = this.custCountry;
    data['cust_email'] = this.custEmail;
    data['cust_firstname'] = this.custFirstname;
    data['cust_lastname'] = this.custLastname;
    data['cust_phone'] = this.custPhone;
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    data['order_id'] = this.orderId;
    return data;
  }
}

class Links {
  String cancelUrl;
  String checkoutUrl;
  String returnUrl;

  Links({this.cancelUrl, this.checkoutUrl, this.returnUrl});

  Links.fromJson(Map<String, dynamic> json) {
    cancelUrl = json['cancel_url'];
    checkoutUrl = json['checkout_url'];
    returnUrl = json['return_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cancel_url'] = this.cancelUrl;
    data['checkout_url'] = this.checkoutUrl;
    data['return_url'] = this.returnUrl;
    return data;
  }
}
