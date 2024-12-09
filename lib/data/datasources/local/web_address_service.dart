import 'dart:js' as js;
import 'address_service.dart';

class WebAddressService implements AddressService {
  @override
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  }) {
    // Register the callback in the global scope
    js.context['handleAddressSelect'] = js.allowInterop((dynamic address) {
      if (address != null) {
        final Map<String, dynamic> addressMap = {
          'Line1': address['Line1'] ?? '',
          'Line2': address['Line2'] ?? '',
          'City': address['City'] ?? '',
          'PostalCode': address['PostalCode'] ?? ''
        };
        onSelect(addressMap);
      }
    });

    // Initialize PCA Address control
    js.context.callMethod('eval', ['''
      window.pca.on('load', function() {
        var fields = {
          elements: {
            search: "$inputId"
          }
        };
        var control = new pca.Address(fields);
        
        control.listen('populate', function(address) {
          handleAddressSelect(address);
        });
      });
    ''']);
  }
}
