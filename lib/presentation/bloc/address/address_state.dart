import 'package:equatable/equatable.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/address_suggestion.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<AddressSuggestion> suggestions;

  const AddressesLoaded({required this.suggestions});

  @override
  List<Object> get props => [suggestions];
}

class AddressLoaded extends AddressState {
  final Address address;

  const AddressLoaded({required this.address});

  @override
  List<Object> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError({required this.message});

  @override
  List<Object> get props => [message];
} 