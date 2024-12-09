import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../data/datasources/local/address_service.dart';
import '../../../domain/entities/address_suggestion.dart';

class AddressLookupField extends StatefulWidget {
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController postcodeController;
  final Function(AddressSuggestion) onAddressSelected;

  const AddressLookupField({
    Key? key,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.postcodeController,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  State<AddressLookupField> createState() => _AddressLookupFieldState();
}

class _AddressLookupFieldState extends State<AddressLookupField> {
  final String inputId = 'address-search-input';
  final _addressService = getAddressService();
  
  @override
  void initState() {
    super.initState();
    
    if (kIsWeb) {
      _addressService.initializeAddressLookup(
        inputId: inputId,
        onSelect: (address) {
          if (address != null) {
            final suggestion = AddressSuggestion.fromJson(address);
            widget.onAddressSelected(suggestion);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return TextField(
        decoration: const InputDecoration(
          labelText: 'Search Address',
          hintText: 'Start typing to search for an address',
          border: OutlineInputBorder(),
        ),
        key: Key(inputId),
      );
    }
    
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Search Address',
        hintText: 'Start typing to search for an address',
        border: OutlineInputBorder(),
      ),
    );
  }
} 