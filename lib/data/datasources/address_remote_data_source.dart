import 'package:dio/dio.dart';
import '../models/address_model.dart';
import '../models/address_suggestion_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressSuggestionModel>> searchAddresses(String searchTerm);
  Future<AddressModel> getAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String baseUrl = 'https://api.addressnow.co.uk/CapturePlus/Interactive';

  AddressRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<List<AddressSuggestionModel>> searchAddresses(String searchTerm) async {
    try {
      final response = await dio.get(
        '$baseUrl/Find/v2.00/json3ex.ws',
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
      );

      if (response.statusCode == 200) {
        return (response.data['Items'] as List)
            .map((item) => AddressSuggestionModel.fromJson(item))
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to search addresses',
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$baseUrl/Find/v2.00/json3ex.ws'),
        error: 'Error searching addresses: $e',
      );
    }
  }

  @override
  Future<AddressModel> getAddress(String id) async {
    try {
      final response = await dio.get(
        '$baseUrl/Retrieve/v2.00/json3ex.ws',
        queryParameters: {
          'Key': apiKey,
          'Id': id,
          'Field1Format': 'Default',
          'Field2Format': 'Default',
          'Field3Format': 'Default',
        },
      );

      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['Address'] ?? {});
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to retrieve address',
      );
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$baseUrl/Retrieve/v2.00/json3ex.ws'),
        error: 'Error retrieving address: $e',
      );
    }
  }
}
