import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_suggestion.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/remote/address_remote_data_source.dart';


class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddressSuggestion>>> searchAddresses(String searchTerm) async {
    try {
      final result = await remoteDataSource.searchAddresses(searchTerm);
      return Right(result);
    } on DioException catch (e) {
      print('Repository DioError: ${e.message} - ${e.response?.data}');
      return Left(ServerFailure());
    } catch (e) {
      print('Repository Error: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Address>> getAddress(String id) async {
    try {
      final result = await remoteDataSource.getAddress(id);
      return Right(result);
    } on DioException catch (e) {
      print('Repository DioError: ${e.message} - ${e.response?.data}');
      return Left(ServerFailure());
    } catch (e) {
      print('Repository Error: $e');
      return Left(ServerFailure());
    }
  }
}

