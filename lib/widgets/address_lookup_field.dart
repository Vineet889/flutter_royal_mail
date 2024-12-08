import 'package:flutter/material.dart';
import 'dart:async';
import '../services/royal_mail_service.dart';
import '../models/address_suggestion.dart';
import '../models/address.dart';

class AddressLookupField extends StatefulWidget {
  final Function(Address) onAddressSelected;
  final String apiKey;
  final TextEditingController? addressLine1Controller;
  final TextEditingController? addressLine2Controller;
  final TextEditingController? cityController;
  final TextEditingController? postcodeController;

  const AddressLookupField({
    Key? key,
    required this.onAddressSelected,
    required this.apiKey,
    this.addressLine1Controller,
    this.addressLine2Controller,
    this.cityController,
    this.postcodeController,
  }) : super(key: key);

  @override
  State<AddressLookupField> createState() => _AddressLookupFieldState();
}

class _AddressLookupFieldState extends State<AddressLookupField> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  late final RoyalMailService _addressService;
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  List<AddressSuggestion> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addressService = RoyalMailService(apiKey: widget.apiKey);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      } else {
        _removeSuggestionsOverlay();
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    try {
      final results = await _addressService.searchAddresses(query);
      setState(() {
        _suggestions = results;
        _isLoading = false;
      });
      _showSuggestionsOverlay();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching addresses: $e')),
      );
    }
  }

  void _showSuggestionsOverlay() {
    _removeSuggestionsOverlay();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                minWidth: size.width,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(
                      suggestion.text,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () => _onSuggestionSelected(suggestion),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeSuggestionsOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _onSuggestionSelected(AddressSuggestion suggestion) async {
    _removeSuggestionsOverlay();
    
    try {
      final address = await _addressService.retrieveAddress(suggestion.id);
      
      // Update the search field
      _searchController.text = suggestion.text;
      
      // Update other form fields if controllers are provided
      widget.addressLine1Controller?.text = address.line1;
      widget.addressLine2Controller?.text = address.line2;
      widget.cityController?.text = address.city;
      widget.postcodeController?.text = address.postalCode;
      
      // Notify parent widget
      widget.onAddressSelected(address);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search Address',
          hintText: 'Enter postcode or street name',
          suffixIcon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _removeSuggestionsOverlay();
    super.dispose();
  }
} 