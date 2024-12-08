class Address {
  final String company;
  final String line1;
  final String line2;
  final String line3;
  final String city;
  final String county;
  final String postalCode;
  final String country;

  Address({
    required this.company,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.city,
    required this.county,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
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
} 