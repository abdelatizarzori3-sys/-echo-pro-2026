import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register repositories
  // getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  // getIt.registerSingleton<ChatRepository>(ChatRepositoryImpl());

  // Register BLoCs
  // getIt.registerSingleton<AuthBloc>(AuthBloc(getIt()));
  // getIt.registerSingleton<ChatBloc>(ChatBloc(getIt()));

  // Services
  // getIt.registerSingleton<NetworkService>(NetworkService());
  // getIt.registerSingleton<StorageService>(StorageService());
}
