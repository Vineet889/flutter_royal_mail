import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_suggestion.dart';
import '../models/address.dart';

class RoyalMailService {
  final String apiKey;
  static const String baseUrl = 'https://api.addressnow.co.uk/CapturePlus/Interactive';

  RoyalMailService({required this.apiKey});

  Future<List<AddressSuggestion>> searchAddresses(String searchTerm) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Find/v2.00/json3ex.ws').replace(
          queryParameters: {
            'Key': apiKey,
            'SearchTerm': searchTerm,
            'LastId': '',
            'SearchFor': 'Everything',
            'Country': 'GBR',
            'LanguagePreference': 'en',
            '\$block': 'true',
            '\$cache': 'true',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['Items'] as List)
            .map((item) => AddressSuggestion.fromJson(item))
            .toList();
      }
      throw Exception('Failed to search addresses: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error searching addresses: $e');
    }
  }

  Future<Address> retrieveAddress(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Retrieve/v2.00/json3ex.ws').replace(
          queryParameters: {
            'Key': apiKey,
            'Id': id,
            'Field1Format': 'Default',
            'Field2Format': 'Default',
            'Field3Format': 'Default',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Address.fromJson(data['Address'] ?? {});
      }
      throw Exception('Failed to retrieve address: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error retrieving address: $e');
    }
  }
} 