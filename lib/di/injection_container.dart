import 'package:get_it/get_it.dart';
import '../core/network/dio_client.dart';
import '../data/datasources/remote/address_remote_data_source.dart';
import '../data/repositories/address_repository_impl.dart';
import '../domain/repositories/address_repository.dart';
import '../domain/usecases/get_address.dart';
import '../domain/usecases/search_addresses.dart';
import '../presentation/bloc/address/address_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(
        apiKey: 'tx12-yy85-mb16-yu94',
      ));

  // Bloc
  sl.registerFactory(
    () => AddressBloc(
      searchAddresses: sl(),
      getAddress: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchAddresses(sl()));
  sl.registerLazySingleton(() => GetAddress(sl()));

  // Repository
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: sl<AddressRemoteDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(
      dioClient: sl(),
    ),
  );
}
