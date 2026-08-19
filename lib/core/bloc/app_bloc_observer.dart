import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('✅ BLoC Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('📤 BLoC Event: ${bloc.runtimeType} -> ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('🔄 BLoC State Change: ${bloc.runtimeType}');
    print('  Previous: ${change.currentState}');
    print('  New: ${change.nextState}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🔁 BLoC Transition: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ BLoC Error: ${bloc.runtimeType} -> $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('🔴 BLoC Closed: ${bloc.runtimeType}');
  }
}
