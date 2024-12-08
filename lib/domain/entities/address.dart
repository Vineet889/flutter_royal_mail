import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String company;
  final String line1;
  final String line2;
  final String line3;
  final String city;
  final String county;
  final String postalCode;
  final String country;

  const Address({
    required this.company,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.city,
    required this.county,
    required this.postalCode,
    required this.country,
  });

  @override
  List<Object> get props => [
        company,
        line1,
        line2,
        line3,
        city,
        county,
        postalCode,
        country,
      ];
}
