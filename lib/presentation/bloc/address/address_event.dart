abstract class AddressEvent {
  const AddressEvent();
}

class SearchAddressesEvent extends AddressEvent {
  final String searchTerm;
  const SearchAddressesEvent(this.searchTerm);
}

class GetAddressEvent extends AddressEvent {
  final String id;
  const GetAddressEvent({required this.id});
} 