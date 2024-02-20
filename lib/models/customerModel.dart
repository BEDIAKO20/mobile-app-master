class Customer {
  String email;
  String firstName;
  String lastName;
  String password;

  Customer({this.email, this.firstName, this.lastName, this.password});
  Customer.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        firstName = json['first_name'],
        lastName=json['last_name'],
        password=json['password'];
        
        

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': firstName + "" + lastName,
    });

    return map;
  }
}
