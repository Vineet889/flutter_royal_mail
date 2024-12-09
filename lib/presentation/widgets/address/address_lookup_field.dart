import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/address_suggestion.dart';
import '../../../data/datasources/local/address_service.dart';

class AddressLookupField extends StatefulWidget {
  final Function(AddressSuggestion) onAddressSelected;
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController postcodeController;

  const AddressLookupField({
    Key? key,
    required this.onAddressSelected,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.postcodeController,
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Search Address',
        border: OutlineInputBorder(),
      ),
    );
  }
} 