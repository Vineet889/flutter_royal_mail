import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/address/address_bloc.dart';
import '../../bloc/address/address_state.dart';
import '../../widgets/address/address_lookup_field.dart';
import '../../../domain/entities/address.dart';
import '../../bloc/address/address_event.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AddressLoaded) {
            _updateFormFields(state.address);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                    AddressLookupField(
                    onAddressSelected: (suggestion) {
                      context.read<AddressBloc>().add(
                            GetAddressEvent(id: suggestion.id),
                          );
                      
                      // Update form fields with parsed components
                      final components = suggestion.parseAddressComponents();
                      _addressLine1Controller.text = components['line1'] ?? '';
                      _addressLine2Controller.text = components['line2'] ?? '';
                      _cityController.text = components['city'] ?? '';
                      _postcodeController.text = components['postcode'] ?? '';
                    },

                    addressLine1Controller: _addressLine1Controller,
                    addressLine2Controller: _addressLine2Controller,
                    cityController: _cityController,
                    postcodeController: _postcodeController,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _addressLine1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 1',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter address line 1';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressLine2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Address Line 2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postcode',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter postcode';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state is AddressLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Handle form submission
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Submit'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateFormFields(Address address) {
    setState(() {
      _addressLine1Controller.text = address.line1;
      _addressLine2Controller.text = address.line2;
      _cityController.text = address.city;
      _postcodeController.text = address.postalCode;
    });
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }
} 