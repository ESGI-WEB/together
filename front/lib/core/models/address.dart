import 'package:latlong2/latlong.dart';

class Address {
  final int id;
  final String street;
  final String number;
  final String city;
  final String zip;
  final LatLng? latlng;

  Address({
    required this.id,
    required this.street,
    required this.number,
    required this.city,
    required this.zip,
    this.latlng,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['ID'],
      street: json['street'],
      number: json['number'],
      city: json['city'],
      zip: json['zip'],
      latlng: json['latitude'] != null && json['longitude'] != null
          ? LatLng(json['latitude'], json['longitude'])
          : null,
    );
  }

  String get fullAddress => '$number $street, $zip $city';

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'street': street,
      'number': number,
      'city': city,
      'zip': zip,
      'latitude': latlng?.latitude,
      'longitude': latlng?.longitude,
    };
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
