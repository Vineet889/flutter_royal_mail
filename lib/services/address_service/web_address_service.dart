import 'dart:js' as js;
import 'address_service_interface.dart';

class WebAddressService implements AddressServiceInterface {
  @override
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  }) {
    js.context.callMethod('initializeAddressNow', [
      inputId,
      js.allowInterop((dynamic address) {
        if (address != null) {
          onSelect(Map<String, dynamic>.from(address));
        } else {
          onSelect(null);
        }
      }),
    ]);
  }
} 