import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'data/datasources/address_remote_data_source.dart';
import 'data/repositories/address_repository_impl.dart';
import 'domain/repositories/address_repository.dart';
import 'domain/usecases/get_address.dart';
import 'domain/usecases/search_addresses.dart';
import 'presentation/bloc/address_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
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
    () => AddressRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(
      dio: sl(),
      apiKey: 'YOUR_API_KEY', // Consider moving this to environment variables
    ),
  );

  // External
  sl.registerLazySingleton(() => Dio());
} 