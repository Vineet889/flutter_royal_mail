import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class SearchAddressesEvent extends AddressEvent {
  final String searchTerm;

  const SearchAddressesEvent(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class GetAddressDetailsEvent extends AddressEvent {
  final String id;

  const GetAddressDetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
