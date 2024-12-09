import 'address_service_interface.dart';

class MobileAddressService implements AddressServiceInterface {
  @override
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  }) {
    // Mobile implementation
  }
}
