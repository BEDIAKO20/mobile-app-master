class UserLogin {
  bool success;
  int statusCode;
  String code;
  String message;
  DataU data;

  UserLogin({this.success, this.statusCode, this.code, this.message, this.data});

  UserLogin.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    if(json['statusCode'] == 200 && json['success'] == true){
      data = json['data'] != null ? new DataU.fromJson(json['data']) : null;
    }else{
      
    }
    // data = json['data'] != null ? new DataU.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataU {
  String token;
  int id;
  String email;
  String nicename;
  String firstname;
  String lastName;
  String displayName;

  DataU(
      {this.token,
      this.id,
      this.email,
      this.nicename,
      this.firstname,
      this.lastName,
      this.displayName});

  DataU.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    nicename = json['nicename'];
    firstname = json['firstName'];
    lastName = json['lastName'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.nicename;
    data['firstName'] = this.firstname;
    data['lastName'] = this.lastName;
    data['displayName'] = this.displayName;
    return data;
  }
}