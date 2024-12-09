abstract class AddressServiceInterface {
  void initializeAddressLookup({
    required String inputId,
    required Function(Map<String, dynamic>?) onSelect,
  });
} 