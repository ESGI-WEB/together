class Address {
  final int id;
  final String street;
  final String number;
  final String city;
  final String zip;

  Address({
    required this.id,
    required this.street,
    required this.number,
    required this.city,
    required this.zip,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['ID'],
      street: json['street'],
      number: json['number'],
      city: json['city'],
      zip: json['zip'],
    );
  }
}

class AddressCreate {
  final String street;
  final String number;
  final String city;
  final String zip;

  AddressCreate({
    required this.street,
    required this.number,
    required this.city,
    required this.zip,
  });

  factory AddressCreate.fromJson(Map<String, dynamic> json) {
    return AddressCreate(
      street: json['street'],
      number: json['number'],
      city: json['city'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'city': city,
      'zip': zip,
    };
  }
}
