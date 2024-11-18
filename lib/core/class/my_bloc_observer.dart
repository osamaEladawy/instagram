import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print(
        "current State ${change.currentState} /onC/ next State ${change.nextState}");
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    print("${bloc.runtimeType} -- onCreate");
    super.onCreate(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(
        "current State ${transition.currentState} /onT/ next State ${transition.nextState}");
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print("event: ${event.runtimeType}");
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print("Error--${error.runtimeType} --- Trace--${stackTrace.runtimeType}");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    print("${bloc.runtimeType} -- is closing");
    super.onClose(bloc);
  }
}
