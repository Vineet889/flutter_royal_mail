import 'package:equatable/equatable.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_suggestion.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressSuggestionsLoaded extends AddressState {
  final List<AddressSuggestion> suggestions;

  const AddressSuggestionsLoaded(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}

class AddressDetailsLoaded extends AddressState {
  final Address address;

  const AddressDetailsLoaded(this.address);

  @override
  List<Object> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}
