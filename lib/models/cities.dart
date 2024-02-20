class Cities {
  String charge;
  String location;

  Cities({this.charge, this.location});

  factory Cities.fromJson(Map<String, dynamic> json) { 
    return Cities(
      charge: json['Charge'],
      location: json['Location'],
    );
  }
  Map<String, dynamic> toJson() => {
        'Charge': charge,
        'Location': location,
      };
 }
