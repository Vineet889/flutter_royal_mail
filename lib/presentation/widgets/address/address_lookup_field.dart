import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address_suggestion.dart';
import '../../bloc/address/address_bloc.dart';
import '../../bloc/address/address_event.dart';
import '../../bloc/address/address_state.dart';

class AddressLookupField extends StatefulWidget {
  final Function(AddressSuggestion) onAddressSelected;
  final TextEditingController? addressLine1Controller;
  final TextEditingController? addressLine2Controller;
  final TextEditingController? cityController;
  final TextEditingController? postcodeController;

  const AddressLookupField({
    super.key,
    required this.onAddressSelected,
    this.addressLine1Controller,
    this.addressLine2Controller,
    this.cityController,
    this.postcodeController,
  });

  @override
  State<AddressLookupField> createState() => _AddressLookupFieldState();
}

class _AddressLookupFieldState extends State<AddressLookupField> {
  final _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isManualInput = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!_isManualInput) return;
    
    if (_searchController.text.isNotEmpty) {
      context.read<AddressBloc>().add(
        SearchAddressesEvent(_searchController.text),
      );
    } else {
      _removeOverlay();
    }
  }

  void _showSuggestions(List<AddressSuggestion> suggestions) {
    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                minWidth: size.width,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index].text),
                    onTap: () => _onSuggestionSelected(suggestions[index]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSuggestionSelected(AddressSuggestion suggestion) {
    _isManualInput = false;
    _searchController.text = suggestion.text;
    _removeOverlay();
    widget.onAddressSelected(suggestion);
    _isManualInput = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressesLoaded) {
          _showSuggestions(state.suggestions);
        }
      },
      builder: (context, state) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Address',
              border: const OutlineInputBorder(),
              suffixIcon: state is AddressLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.search),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }
} 