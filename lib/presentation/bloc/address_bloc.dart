import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_address.dart';
import '../../domain/usecases/search_addresses.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final SearchAddresses searchAddresses;
  final GetAddress getAddress;

  AddressBloc({
    required this.searchAddresses,
    required this.getAddress,
  }) : super(AddressInitial()) {
    on<SearchAddressesEvent>(_onSearchAddresses);
    on<GetAddressDetailsEvent>(_onGetAddressDetails);
  }

  Future<void> _onSearchAddresses(
    SearchAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await searchAddresses(SearchParams(searchTerm: event.searchTerm));
    result.fold(
      (failure) => emit(const AddressError('Failed to search addresses')),
      (suggestions) => emit(AddressSuggestionsLoaded(suggestions)),
    );
  }

  Future<void> _onGetAddressDetails(
    GetAddressDetailsEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await getAddress(GetAddressParams(id: event.id));
    result.fold(
      (failure) => emit(const AddressError('Failed to get address details')),
      (address) => emit(AddressDetailsLoaded(address)),
    );
  }
}
