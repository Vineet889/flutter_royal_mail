import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/address_suggestion.dart';
import '../repositories/address_repository.dart';

class SearchAddresses implements UseCase<List<AddressSuggestion>, SearchParams> {
  final AddressRepository repository;

  SearchAddresses(this.repository);

  @override
  Future<Either<Failure, List<AddressSuggestion>>> call(SearchParams params) async {
    return await repository.searchAddresses(params.searchTerm);
  }
}

class SearchParams extends Equatable {
  final String searchTerm;

  const SearchParams({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}
