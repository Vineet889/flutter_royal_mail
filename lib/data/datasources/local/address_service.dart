import 'package:flutter/foundation.dart';
import 'web_address_service.dart';
import 'mobile_address_service.dart';

abstract class AddressService {
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  });
}

AddressService getAddressService() {
  if (kIsWeb) {
    return WebAddressService();
  }
  return MobileAddressService();
}
