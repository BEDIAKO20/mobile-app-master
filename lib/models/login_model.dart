class ErrorLogin {
  bool success;
  int statusCode;
  String code;
  String message;
  List<Null> data;

  ErrorLogin(
      {this.success, this.statusCode, this.code, this.message, this.data});

  ErrorLogin.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Null>();
      
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = null;
    }
    return data;
  }
   @override
  toString() => this.toJson().toString();
}
