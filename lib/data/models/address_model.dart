import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.company,
    required super.line1,
    required super.line2,
    required super.line3,
    required super.city,
    required super.county,
    required super.postalCode,
    required super.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      company: json['Company'] ?? '',
      line1: json['Line1'] ?? '',
      line2: json['Line2'] ?? '',
      line3: json['Line3'] ?? '',
      city: json['City'] ?? '',
      county: json['County'] ?? '',
      postalCode: json['PostalCode'] ?? '',
      country: json['Country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Company': company,
      'Line1': line1,
      'Line2': line2,
      'Line3': line3,
      'City': city,
      'County': county,
      'PostalCode': postalCode,
      'Country': country,
    };
  }
}
