import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  // Network
  getIt.registerSingleton<DioClient>(DioClient(getIt<FlutterSecureStorage>()));

  // Features are registered in their own modules
  // Each feature registers its datasources, repositories, usecases, and blocs
}
