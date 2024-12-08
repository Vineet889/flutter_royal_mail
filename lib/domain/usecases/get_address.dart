import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetAddress implements UseCase<Address, GetAddressParams> {
  final AddressRepository repository;

  GetAddress(this.repository);

  @override
  Future<Either<Failure, Address>> call(GetAddressParams params) async {
    return await repository.getAddress(params.id);
  }
}

class GetAddressParams extends Equatable {
  final String id;

  const GetAddressParams({required this.id});

  @override
  List<Object> get props => [id];
}
