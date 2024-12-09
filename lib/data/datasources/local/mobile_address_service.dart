import 'address_service.dart';

class MobileAddressService implements AddressService {
  @override
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  }) {
    // Mobile implementation would go here
    print('Mobile address lookup not implemented');
  }
}
