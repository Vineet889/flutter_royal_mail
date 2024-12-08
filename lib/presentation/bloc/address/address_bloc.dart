import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_address.dart';
import '../../../domain/usecases/search_addresses.dart';
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
    on<GetAddressEvent>(_onGetAddress);
  }

  Future<void> _onSearchAddresses(
    SearchAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await searchAddresses(SearchParams(searchTerm: event.searchTerm));
    result.fold(
      (failure) => emit(AddressError(message: failure.toString())),
      (suggestions) => emit(AddressesLoaded(suggestions: suggestions)),
    );
  }

  Future<void> _onGetAddress(
    GetAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await getAddress(GetAddressParams(id: event.id));
    result.fold(
      (failure) => emit(AddressError(message: failure.toString())),
      (address) => emit(AddressLoaded(address: address)),
    );
  }
} 