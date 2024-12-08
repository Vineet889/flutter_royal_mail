import 'package:dartz/dartz.dart';
import '../entities/address.dart';
import '../entities/address_suggestion.dart';
import '../../core/error/failures.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressSuggestion>>> searchAddresses(String searchTerm);
  Future<Either<Failure, Address>> getAddress(String id);
}
