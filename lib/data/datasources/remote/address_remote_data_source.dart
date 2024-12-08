import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/address_model.dart';
import '../../models/address_suggestion_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressSuggestionModel>> searchAddresses(String searchTerm);
  Future<AddressModel> getAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final DioClient dioClient;

  const AddressRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<AddressSuggestionModel>> searchAddresses(String searchTerm) async {
    try {
      final response = await dioClient.get(
        ApiConstants.findEndpoint,
        queryParameters: {
          'SearchTerm': searchTerm,
          'LastId': '',
          'SearchFor': 'Everything',
          'Country': 'GBR',
          'LanguagePreference': 'en',
          '\$block': 'true',
          '\$cache': 'true',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final items = response.data['Items'] as List<dynamic>?;
        if (items != null) {
          return items
              .map((item) => AddressSuggestionModel.fromJson(item))
              .toList();
        }
      }
      throw DioException(
        requestOptions: RequestOptions(path: ApiConstants.findEndpoint),
        error: 'Invalid response format',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressModel> getAddress(String id) async {
    try {
      final response = await dioClient.get(
        ApiConstants.retrieveEndpoint,
        queryParameters: {
          'Id': id,
          'Field1Format': 'Default',
          'Field2Format': 'Default',
          'Field3Format': 'Default',
        },
      );

      print('GetAddress Response: ${response.data}'); // For debugging

      if (response.statusCode == 200 && response.data != null) {
        final addressData = response.data['Items']?[0] ?? response.data['Address'];
        if (addressData != null) {
          return AddressModel.fromJson(addressData);
        }
      }
      
      // If we get here, we have a successful response but no address data
      throw DioException(
        requestOptions: RequestOptions(path: ApiConstants.retrieveEndpoint),
        error: 'No address data found in response',
      );
    } on DioException catch (e) {
      print('DioError in getAddress: ${e.message} - ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error in getAddress: $e');
      rethrow;
    }
  }
} 