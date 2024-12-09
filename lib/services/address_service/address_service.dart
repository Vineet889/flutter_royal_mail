import 'package:flutter/foundation.dart';
import 'web_address_service.dart';
import 'mobile_address_service.dart';
import 'address_service_interface.dart';

AddressServiceInterface getAddressService() {
  if (kIsWeb) {
    return WebAddressService();
  } else {
    return MobileAddressService();
  }
} 