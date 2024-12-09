import 'dart:js' as js;

class AddressNowJsService {
  static void initializeAddressNow({
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